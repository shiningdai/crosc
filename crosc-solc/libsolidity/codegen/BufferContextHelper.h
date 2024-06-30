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
/**
 * Code generator at the contract level. Can be used to generate code for exactly one contract
 * either in "runtime mode" or "creation mode".
 */
class BufferContextHelper: private ASTConstVisitor
{
public:
	explicit BufferContextHelper() {}
	// ~BufferContextHelper() {}

	std::map<VariableDeclaration const*, size_t> getVarCounter(Block const* codeBlock);
	// void cleanCounter(){ m_varCounter.clear(); };

private:
	// bool visit(VariableDeclaration const& _variableDeclaration) override;
	// bool visit(FunctionDefinition const& _function) override;
	// bool visit(InlineAssembly const& _inlineAssembly) override;
	// bool visit(TryStatement const& _tryStatement) override;
	// bool visit(TryCatchClause const& _clause) override;
	// bool visit(IfStatement const& _ifStatement) override;
	// bool visit(WhileStatement const& _whileStatement) override;
	// bool visit(ForStatement const& _forStatement) override;
	// bool visit(Continue const& _continueStatement) override;
	// bool visit(Break const& _breakStatement) override;
	// bool visit(Return const& _return) override;
	// bool visit(Throw const& _throw) override;
	// bool visit(EmitStatement const& _emit) override;
	// bool visit(RevertStatement const& _revert) override;
	// bool visit(VariableDeclarationStatement const& _variableDeclarationStatement) override;
	// bool visit(ExpressionStatement const& _expressionStatement) override;
	// bool visit(PlaceholderStatement const&) override;
	// bool visit(Block const& _block) override;
	// void endVisit(Block const& _block) override;
	// bool visit(Assignment const& _assignment) override;
	// void endVisit(Identifier const& _identifier) override;
	bool visit(Identifier const& _identifier) override;

	std::map<VariableDeclaration const*, size_t>  m_varCounter;
	
};

}