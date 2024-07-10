package main

import "core:fmt"
import "core:os"

Errors :: enum{OK, NotInMap, MapFull}

capacity :: 32

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
    hashmap.data = make([dynamic]Data, capacity)
    return hashmap
}

map_insert :: proc(hashmap: ^Map, key: string, val: int) -> Errors {
    index := hash(key) % cap(hashmap.data) 

    data := Data{val, key, true}

    iterated_by := 0
    for hashmap.data[index].unavailable == true {
        if iterated_by >= cap(hashmap.data) { return Errors.MapFull }
        index += 1
        iterated_by += 1
        if index >= cap(hashmap.data) { index = 0 }
    }

    assign_at(&hashmap.data, index, data)
    return Errors.OK
}

map_get :: proc(hashmap: ^Map, key: string) -> (int, Errors) {
    index := hash(key) % cap(hashmap.data) 

    iterated_by := 0
    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return 0, Errors.NotInMap 
        }
        if iterated_by >= cap(hashmap.data) { return 0, Errors.MapFull }
        index += 1
        iterated_by += 1
        if index >= cap(hashmap.data) { index = 0 }
    }

    return hashmap.data[index].val, Errors.OK
}

map_delete :: proc(hashmap: ^Map, key: string) -> Errors {
    index := hash(key) % cap(hashmap.data) 

    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return Errors.NotInMap
        }
        if index >= cap(hashmap.data) { index = 0 }
        index += 1
    }
    
    assign_at(&hashmap.data, index, Data{})
    return Errors.OK
}

map_clear :: proc(hashmap: ^Map) {
    clear(&hashmap.data)
}

data_print :: proc(data: ^Data) {
    fmt.printf("val: %d, key: %s\n", data.val, data.key)
}

map_print :: proc(hashmap: ^Map) {
    for &val, index in hashmap.data {
        if(val.unavailable) {
            fmt.printf("index: %d, ", index)
            data_print(&val)
        }
    }
}

main :: proc() {
    hashmap := map_init()
    err := map_insert(&hashmap, "test2", 5)
    if err != Errors.OK {
        fmt.eprintln("could not insert")
        os.exit(1)
    }
    err = map_insert(&hashmap, "test", 10)
    if err != Errors.OK {
        fmt.eprintln("could not insert")
        os.exit(1)
    }
    err = map_insert(&hashmap, "test3", 10)
    if err != Errors.OK {
        fmt.eprintln("could not insert")
        os.exit(1)
    }

    val: int = 0
    val, err = map_get(&hashmap, "test3")
    if err != Errors.OK {
        fmt.eprintln("could not get element")
        os.exit(1)
    }

    map_print(&hashmap)
}



