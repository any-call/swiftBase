import Testing
@testable import swiftBase

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test
func testDohQueryTxt() async throws {
    let txts = try await myDOH.QueryTxt(timeout: 8, domain: "sslink.api.prefix.stcoin.uk")
    
    #expect(!txts.isEmpty)
    print("Txt =",txts)
}

@Test func testDecryTxt() throws {
    let orgStr  = "this is a testthis is a testthis is a testthis is a test"
    let key  = "098765453209876545320987654532qa"
    let enCry = try myDOH.EncryptTxt(orgStr, key: Data(key.utf8))
    print("enCry is :",enCry)
    let deCry = try myDOH.DecryptTxt("zxPv22CuMJ0YAbB3dkblA5h+i04e7KgkJ+Remk6XeGvNzN0pz6y/AROzU+mzDUyZUdMPb9bnfxjCZjxNbiTelt51zV9cZRJNXEy1H0MpbnVscD20", key: Data(key.utf8))
    print("deCry is :",deCry)
}
