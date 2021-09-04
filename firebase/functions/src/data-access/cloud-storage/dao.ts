import * as admin from 'firebase-admin'
import { Bucket } from '@google-cloud/storage'
import * as fs from 'fs'
import * as os from 'os'
import * as path from 'path'

interface FileMeta {
    downloadURL: string
}


export interface CloudStorageDAOInterface {


    /**
     * 
     * @param directory 
     * @param filename 
     * @param fileExt 
     * @param data 
     * @param options 
     * @param isPublic 
     */
    writeFile(directory: string, filename: string, fileExt: string, data: any, options: fs.WriteFileOptions, isPublic: boolean): Promise<FileMeta>


    /**
     * 
     * @param path 
     */
    readFile(path: string): Promise<any>

}


export class CloudStorageDAO implements CloudStorageDAOInterface {

    private bucket: Bucket

    constructor(storage: admin.storage.Storage) {
        this.bucket = storage.bucket()
    }


    async writeFile(directory: string, filename: string, fileExt: string, data: any, options: fs.WriteFileOptions, isPublic: boolean): Promise<FileMeta> {

        const storagePath = `${directory}/${filename}.${fileExt}`

        const tmpPath = path.join(os.tmpdir(), `${filename}.${fileExt}`)

        fs.writeFileSync(tmpPath, data, options)
        // let buff = Buffer.from(data, 'base64')

        // if (options && options.toString() === 'base64') {
        //     fs.writeFileSync(tmpPath, data, options)
        // }else{
        //     fs.writeFileSync(tmpPath, data)
        // }

        const downloadURL: string = await this.bucket.upload(tmpPath, {
            destination: storagePath,
            public: isPublic
        }).then(res => {
            return res[0].getMetadata().then(metaRes => metaRes[0].mediaLink)
        })

        fs.unlinkSync(tmpPath)

        return Promise.resolve({
            downloadURL: downloadURL
        })

    }

    readFile(path: string): Promise<any> {
        return this.bucket.file(path).download().then(res => {
            const buffer = res[0]
            return buffer.toString()
        }).catch(err => {
            if (err.code === 404) {
                throw new Error(`File not found at path: ${path}.`)
            }
        })

    }



}