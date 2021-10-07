import axios from 'axios'

export default axios.create(
    {
        baseURL: "https://us-central1-karpool-1ea95.cloudfunctions.net/"
    }
)