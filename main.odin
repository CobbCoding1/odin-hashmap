package main

import "core:fmt"

Data :: struct {
    val: int,
    key: string,
    unavailable: bool,
}

Map :: struct {
    data: [dynamic]Data,
}

hash :: proc(n: string) -> int {
    result: int = 0
    for ch in n {
        result += (cast(int)ch * 10 + 2) / 3 
    }
    return result
}

map_init :: proc() -> Map {
    hashmap := Map{}
    hashmap.data = make([dynamic]Data, 32)
    return hashmap
}

map_insert :: proc(hashmap: ^Map, key: string, val: int) {
    index := hash(key) % cap(hashmap.data) 

    data := Data{val, key, true}

    for hashmap.data[index].unavailable == true {
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }

    assign_at(&hashmap.data, index, data)
}

map_get :: proc(hashmap: ^Map, key: string) -> int {
    index := hash(key) % cap(hashmap.data) 

    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return -1
        }
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }

    return hashmap.data[index].val
}

map_delete :: proc(hashmap: ^Map, key: string) {
    index := hash(key) % cap(hashmap.data) 

    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return
        }
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }
    
    assign_at(&hashmap.data, index, Data{})
}

main :: proc() {
    hashmap := map_init()
    map_insert(&hashmap, "test2", 5)
    map_insert(&hashmap, "test", 10)

    for i in 0..<32 {
        //fmt.println(i, hash(i) % cap(hashmap.data))
    }

    for val in hashmap.data {
        fmt.println(val)
    }
}



