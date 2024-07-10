package main

import "core:fmt"
import "core:os"

Errors :: enum{OK, NotInMap, MapFull}

capacity :: 32

Data_Union :: union($T: typeid) {T, Errors}

Data :: struct {
    val: Data_Union(T),
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

map_insert :: proc(hashmap: ^Map, key: string, val: T) -> Errors {
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

map_get :: proc(hashmap: ^Map, key: string) -> Data_Union(T) {
    index := hash(key) % cap(hashmap.data) 

    iterated_by := 0
    for hashmap.data[index].key != key {
        if hashmap.data[index].unavailable {
            return Errors.NotInMap 
        }
        if iterated_by >= cap(hashmap.data) { return Errors.MapFull }
        index += 1
        iterated_by += 1
        if index >= cap(hashmap.data) { index = 0 }
    }

    return hashmap.data[index].val
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
    fmt.println("val:", data.val, "key:", data.key)
}

map_print :: proc(hashmap: ^Map) {
    for &val, index in hashmap.data {
        if(val.unavailable) {
            fmt.printf("index: %d, ", index)
            data_print(&val)
        }
    }
}

T :: string 

main :: proc() {
    hashmap := map_init()
    err := map_insert(&hashmap, "test2", "test")
    if err != Errors.OK {
        fmt.eprintln("could not insert")
        os.exit(1)
    }

    val, ok := map_get(&hashmap, "test2").(T)
    if !ok {
        fmt.eprintln("could not get element")
        os.exit(1)
    }

    map_print(&hashmap)
}



