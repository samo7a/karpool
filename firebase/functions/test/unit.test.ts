


import { add } from '../src/index'

test('Basic add', () => {
    const a = 5
    const b = 2
    expect(add(a, b)).toBe(a + b)
})