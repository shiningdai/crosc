/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0
/**
 * @author Christian <c@ethdev.com>
 * @date 2014
 * Code generator for contracts.
 */

#pragma once

#include <libsolidity/ast/ASTVisitor.h>
#include <libsolidity/codegen/CompilerContext.h>
#include <libsolidity/interface/DebugSettings.h>
#include <libevmasm/Assembly.h>
#include <functional>
#include <ostream>
#include <map>

namespace solidity::frontend
{

// class StateVariableRetriveUtil: private ASTConstVisitor
// {
//  /**
//   * 这个类用于辅助AST树节点的检索，检索过程中不对树节点和上下文产生影响
//   * 只用检索节点子路径上是否存在某种类型的节点以及个数。
//   * 主要是针对状态变量类型的节点
//   */
// public:
// void retriveStateVar(Block const* codeBlock);

// };

/**
 * Code generator at the contract level. Can be used to generate code for exactly one contract
 * either in "runtime mode" or "creation mode".
 */
class ContractCompiler: private ASTConstVisitor
{
public:
	explicit ContractCompiler(
		ContractCompiler* _runtimeCompiler,
		CompilerContext& _context,
		OptimiserSettings _optimiserSettings
	):
		m_optimiserSettings(std::move(_optimiserSettings)),
		m_runtimeCompiler(_runtimeCompiler),
		m_context(_context)
	{
	}

	void compileContract(
		ContractDefinition const& _contract,
		std::map<ContractDefinition const*, std::shared_ptr<Compiler const>> const& _otherCompilers
	);
	/// Compiles the constructor part of the contract.
	/// @returns the identifier of the runtime sub-assembly.
	size_t compileConstructor(
		ContractDefinition const& _contract,
		std::map<ContractDefinition const*, std::shared_ptr<Compiler const>> const& _otherCompilers
	);

	// 一个合约函数中涉及到的状态变量引用计数
	std::map<VariableDeclaration const*, size_t>  m_varCounterC;
	// 给ContractCompiler增加一个成员变量bool m_fromFunction;
	// 从函数解析路径进入的给他置为true，等将来传递给ExpressionCompiler
	bool m_fromFunctionC = false;

private:
	/// Registers the non-function objects inside the contract with the context and stores the basic
	/// information about the contract like the AST annotations.
	void initializeContext(
		ContractDefinition const& _contract,
		std::map<ContractDefinition const*, std::shared_ptr<Compiler const>> const& _otherCompilers
	);
	/// Adds the code that is run at creation time. Should be run after exchanging the run-time context
	/// with a new and initialized context. Adds the constructor code.
	/// @returns the identifier of the runtime sub assembly
	size_t packIntoContractCreator(ContractDefinition const& _contract);
	/// Appends code that deploys the given contract as a library.
	/// Will also add code that modifies the contract in memory by injecting the current address
	/// for the call protector.
	size_t deployLibrary(ContractDefinition const& _contract);
	/// Appends state variable initialisation and constructor code.
	void appendInitAndConstructorCode(ContractDefinition const& _contract);
	void appendBaseConstructor(FunctionDefinition const& _constructor);
	void appendConstructor(FunctionDefinition const& _constructor);
	/// Appends code that returns a boolean flag on the stack that tells whether
	/// the contract has been called via delegatecall (false) or regular call (true).
	/// This is done by inserting a specific push constant as the first instruction
	/// whose data will be modified in memory at deploy time.
	void appendDelegatecallCheck();
	/// Appends the function selector. Is called recursively to create a binary search tree.
	/// @a _runs the number of intended executions of the contract to tune the split point.
	void appendInternalSelector(
		std::map<util::FixedHash<4>, evmasm::AssemblyItem const> const& _entryPoints,
		std::vector<util::FixedHash<4>> const& _ids,
		evmasm::AssemblyItem const& _notFoundTag,
		size_t _runs
	);
	void appendFunctionSelector(ContractDefinition const& _contract);
	void appendCallValueCheck();
	void appendReturnValuePacker(TypePointers const& _typeParameters, bool _isLibrary);

	void registerStateVariables(ContractDefinition const& _contract);
	void registerBufferMaps(ContractDefinition const& _contract);

	void registerImmutableVariables(ContractDefinition const& _contract);
	void initializeStateVariables(ContractDefinition const& _contract);

	bool visit(VariableDeclaration const& _variableDeclaration) override;
	bool visit(FunctionDefinition const& _function) override;
	bool visit(InlineAssembly const& _inlineAssembly) override;
	bool visit(TryStatement const& _tryStatement) override;
	void handleCatch(std::vector<ASTPointer<TryCatchClause>> const& _catchClauses);
	bool visit(TryCatchClause const& _clause) override;
	bool visit(IfStatement const& _ifStatement) override;
	bool visit(WhileStatement const& _whileStatement) override;
	bool visit(ForStatement const& _forStatement) override;
	bool visit(Continue const& _continueStatement) override;
	bool visit(Break const& _breakStatement) override;
	bool visit(Return const& _return) override;
	bool visit(Throw const& _throw) override;
	bool visit(EmitStatement const& _emit) override;
	bool visit(RevertStatement const& _revert) override;
	bool visit(VariableDeclarationStatement const& _variableDeclarationStatement) override;
	bool visit(ExpressionStatement const& _expressionStatement) override;
	bool visit(PlaceholderStatement const&) override;
	bool visit(Block const& _block) override;
	void endVisit(Block const& _block) override;

	/// Repeatedly visits all function which are referenced but which are not compiled yet.
	void appendMissingFunctions();

	/// Appends one layer of function modifier code of the current function, or the function
	/// body itself if the last modifier was reached.
	void appendModifierOrFunctionCode();

	/// Creates a stack slot for the given variable and assigns a default value.
	/// If the default value is complex (needs memory allocation) and @a _provideDefaultValue
	/// is false, this might be skipped.
	void appendStackVariableInitialisation(VariableDeclaration const& _variable, bool _provideDefaultValue);
	void compileExpression(Expression const& _expression, Type const* _targetType = nullptr);

	/// Frees the variables of a certain scope (to be used when leaving).
	void popScopedVariables(ASTNode const* _node);

	/// Sets the stack height for the visited loop.
	void storeStackHeight(ASTNode const* _node);

	OptimiserSettings const m_optimiserSettings;
	/// Pointer to the runtime compiler in case this is a creation compiler.
	ContractCompiler* m_runtimeCompiler = nullptr;
	CompilerContext& m_context;

	/// Tag to jump to for a "break" statement and the stack height after freeing the local loop variables.
	std::vector<std::pair<evmasm::AssemblyItem, unsigned>> m_breakTags;
	/// Tag to jump to for a "continue" statement and the stack height after freeing the local loop variables.
	std::vector<std::pair<evmasm::AssemblyItem, unsigned>> m_continueTags;
	/// Tag to jump to for a "return" statement and the stack height after freeing the local function or modifier variables.
	/// Needs to be stacked because of modifiers.
	std::vector<std::pair<evmasm::AssemblyItem, unsigned>> m_returnTags;
	unsigned m_modifierDepth = 0;
	FunctionDefinition const* m_currentFunction = nullptr;

	// arguments for base constructors, filled in derived-to-base order
	std::map<FunctionDefinition const*, ASTNode const*> const* m_baseArguments;

	/// Stores the variables that were declared inside a specific scope, for each modifier depth.
	std::map<unsigned, std::map<ASTNode const*, unsigned>> m_scopeStackHeight;
};

}
