extension ViewFactory.Environment {
    static let mock = Self(
        data: .mock,
        uuid: { .mock },
        gcd: .mock
    )
}
