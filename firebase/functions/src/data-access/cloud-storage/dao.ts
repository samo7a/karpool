import * as admin from 'firebase-admin'
import { Bucket } from '@google-cloud/storage'

interface FileMeta {
    downloadURL: string
}


export interface CloudStorageDAOInterface {


    /**
     * 
     * @param directory 
     * @param filename 
     * @param fileExt 
     * @param isPublic 
     */
    writeFile(directory: string, filename: string, fileExt: string, isPublic: boolean): Promise<FileMeta>


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


    writeFile(directory: string, filename: string, fileExt: string, isPublic: boolean): Promise<FileMeta> {
        console.log(this.bucket)
        return Promise.resolve({
            downloadURL: 'https://google.com'
        })

    }
    readFile(path: string): Promise<any> {
        throw new Error("Method not implemented.");
    }



}