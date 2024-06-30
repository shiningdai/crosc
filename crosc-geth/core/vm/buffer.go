// Copyright 2015 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.

package vm

import (
	"github.com/holiman/uint256"
)

// Buffer implemts a key-val map model for mapping all the state variables
// Buffer本质上用一个字节数组实现，由于编译时采用的是下标索引，且以32字节为读写单元
// 所以，读取数据时，通过 index * 32 计算偏移
type Buffer struct {
	store []byte
	// lastGasCost uint64
}

// NewBuffer returns a new Buffer model.
func NewBuffer() *Buffer {
	return &Buffer{}
}

// Set32 sets the 32 bytes starting at offset to the value of val, left-padded with zeroes to
// 32 bytes.
func (b *Buffer) Set32(index uint64, val *uint256.Int) {
	// // log
	// buffer_log, _err_op := os.OpenFile("/home/dsr/experiments/m_ethereum/solcplus_verify/interpreter-logs/230612/bufStore_230612_2.log", os.O_CREATE|os.O_APPEND|os.O_RDWR, os.ModePerm)
	// if _err_op != nil {
	// 	fmt.Println(_err_op.Error())
	// }
	// defer buffer_log.Close()
	// length of store may never be less than offset + size.
	// The store should be resized PRIOR to setting the Buffer
	// buffer_log.WriteString("Before verify length of store\n")
	if index+32 > uint64(len(b.store)) {
		panic("invalid Buffer: store empty")
	}

	// Fill in relevant bits
	b32 := val.Bytes32()
	copy(b.store[index*32:(index+1)*32], b32[:])
	// // log
	// log_str := fmt.Sprintf("\nBSTORE args:\nbuffer index:%v\nvalue to store:%v\n", index, b32)
	// buffer_log.WriteString(log_str)
}

// Resize resizes the Buffer to size
func (b *Buffer) Resize(size uint64) {
	if uint64(b.Len()) < size {
		b.store = append(b.store, make([]byte, size-uint64(b.Len()))...)
	}
}

// GetPtr returns the offset + size
func (b *Buffer) GetPtr(index int64) []byte {
	// // log
	// buffer_log, _err_op := os.OpenFile("/home/dsr/experiments/m_ethereum/solcplus_verify/interpreter-logs/230612/bufLoad_230612_2.log", os.O_CREATE|os.O_APPEND|os.O_RDWR, os.ModePerm)
	// if _err_op != nil {
	// 	fmt.Println(_err_op.Error())
	// }
	// defer buffer_log.Close()

	if len(b.store) >= int((index+1)*32) {
		// // log
		// log_str := fmt.Sprintf("\nBLOAD args:\nbuffer index:%v\nvalue loaded:%v\n", int(index), b.store[index*32:(index+1)*32])
		// buffer_log.WriteString(log_str)
		return b.store[index*32 : (index+1)*32]
	}

	return nil
}

// Len returns the length of the backing slice
func (b *Buffer) Len() int {
	return len(b.store)
}

// Data returns the backing slice
func (b *Buffer) Data() []byte {
	return b.store
}
