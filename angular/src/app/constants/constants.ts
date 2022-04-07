import { Injectable } from "@angular/core";

@Injectable() 
export class Constants {
public readonly API_ENDPOINT: string = 'http://api.sameerkhanna.net/'; 
public readonly FILEUPLOAD_ENDPOINT: string = this.API_ENDPOINT + 'uploadImage'; 
public readonly PDFGENERATE_ENDPOINT: string = this.API_ENDPOINT + 'generatePdf';
} 