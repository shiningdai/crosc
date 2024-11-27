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
 * Solidity compiler.
 */


#include <libsolidity/ast/AST.h>
#include <libsolidity/ast/ASTUtils.h>
#include <libsolidity/ast/TypeProvider.h>
#include <libsolidity/codegen/CompilerUtils.h>
#include <libsolidity/codegen/ContractCompiler.h>
#include <libsolidity/codegen/ExpressionCompiler.h>
#include <libsolidity/codegen/BufferContextHelper.h>

#include <libyul/AsmAnalysisInfo.h>
#include <libyul/AsmAnalysis.h>
#include <libyul/AST.h>
#include <libyul/backends/evm/AsmCodeGen.h>
#include <libyul/backends/evm/EVMMetrics.h>
#include <libyul/backends/evm/EVMDialect.h>
#include <libyul/optimiser/Suite.h>
#include <libyul/Object.h>
#include <libyul/optimiser/ASTCopier.h>
#include <libyul/YulString.h>

#include <libevmasm/Instruction.h>
#include <libevmasm/Assembly.h>
#include <libevmasm/GasMeter.h>

#include <liblangutil/ErrorReporter.h>

#include <libsolutil/Whiskers.h>
#include <libsolutil/FunctionSelector.h>
#include <libsolutil/StackTooDeepString.h>

#include <range/v3/view/reverse.hpp>

#include <algorithm>
#include <limits>

using namespace std;
using namespace solidity;
using namespace solidity::evmasm;
using namespace solidity::frontend;
using namespace solidity::langutil;

using solidity::util::FixedHash;
using solidity::util::h256;
using solidity::util::errinfo_comment;


// 在函数体中访问到哪些状态变量的访问
// 由此还可以进行更细粒度的控制，如果变量只存在一次访问，可以不进行替换
std::map<VariableDeclaration const*, size_t> BufferContextHelper::getVarCounter(Block const* codeBlock)
{
	// clean up m_varCounter
	m_varCounter.clear();
	codeBlock->accept(*this);
	return m_varCounter;
}

// // 在最终遍历到叶子节点前，所有的节点的visit的返回True保证从codeBlock为根节点的整棵树都被遍历到
// bool BufferContextHelper::visit(VariableDeclaration const& _variableDeclaration)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(FunctionDefinition const& _function)
// {
//     return true;
// }
// bool BufferContextHelper::visit(InlineAssembly const& _inlineAssembly)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(TryStatement const& _tryStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(TryCatchClause const& _clause)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(IfStatement const& _ifStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(WhileStatement const& _whileStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(ForStatement const& _forStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(Continue const& _continueStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(Break const& _breakStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(Return const& _return)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(Throw const& _throw)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(EmitStatement const& _emit)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(RevertStatement const& _revert)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(VariableDeclarationStatement const& _variableDeclarationStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(ExpressionStatement const& _expressionStatement)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(PlaceholderStatement const&)
// {
// 	return true;
// }
// bool BufferContextHelper::visit(Block const& _block)
// {
// 	if (_block != nullptr)
// 		return true;
// 	return false;
// }
// void BufferContextHelper::endVisit(Block const& _block)
// {
// 	return;
// }
// bool BufferContextHelper::visit(Assignment const& _assignment)
// {
// 	_assignment->rightHandSide()->accept(*this);
// 	_assignment->leftHandSide()->accept(*this);
// }
bool BufferContextHelper::visit(Identifier const& _identifier)
{
	if (_identifier.annotation().referencedDeclaration == nullptr)
		return false;
	auto _variableDeclaration = dynamic_cast<VariableDeclaration const*>(_identifier.annotation().referencedDeclaration);
	if (_variableDeclaration == nullptr)
		return false;
	Type const* _type = _variableDeclaration->annotation().type;
	// Type const* _type = _variableDeclaration->value()->annotation().type;
	// if ( _variableDeclaration->isStateVariable() && _type->isValueType())
	if ( _variableDeclaration->isStateVariable() && _type->isValueType() && !_variableDeclaration->isConstant())
	{
		if (m_varCounter.count(_variableDeclaration) == 0)
			m_varCounter[_variableDeclaration] = 1;
		else
			m_varCounter[_variableDeclaration] += 1;
	}
	return false;
}
// void BufferContextHelper::endVisit(Identifier const& _identifier)
// {
//     return;
// }