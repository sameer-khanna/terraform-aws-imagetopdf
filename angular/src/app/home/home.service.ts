import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import 'rxjs/add/operator/map'
import { Constants } from '../constants/constants';

@Injectable({
  providedIn: 'root'
})
export class HomeService {

  constructor(private http: HttpClient, private constants: Constants) {
  }


  postFile(fileToUpload: File): Observable<boolean> {
    const endpoint = 'your-destination-url';
    const formData: FormData = new FormData();
    formData.append('fileKey', fileToUpload, fileToUpload.name);
    return this.http.post<boolean>(endpoint, formData,);
  }

  uploadFile(formData: FormData): Promise<string> {
    const headers = new HttpHeaders();
    return this.http.post(this.constants.FILEUPLOAD_ENDPOINT, formData, { headers, responseType: 'text'}).
      map(data => {
        return data;
      }).toPromise();
  }

  generatePDF(formData: FormData): Promise<string> {
    const headers = new HttpHeaders();
    return this.http.post(this.constants.PDFGENERATE_ENDPOINT, formData, { headers, responseType: 'text'}).
      map(data => {
        return data;
      }).toPromise();
  }
}
