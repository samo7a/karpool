
import * as functions from 'firebase-functions'

interface EnvConfig {
    stripe: {
        public_key: string
        private_key: string
    }
    directions_api: {
        private_key: string
    }
}

export function getEnv(): EnvConfig {
    return functions.config() as EnvConfig
}