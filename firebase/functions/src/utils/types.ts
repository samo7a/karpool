
/**
 * https://stackoverflow.com/a/47914631/6738247
 * Allows optional values for nested properties.
 * Useful for DAO update methods with objects that have nested fields.
 */
export type DeepPartial<T> = T extends never[] ? T : { [P in keyof T]?: DeepPartial<T[P]> }