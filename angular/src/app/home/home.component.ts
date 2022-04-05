import { Component, ElementRef, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';
import { MatTabChangeEvent } from '@angular/material/tabs';
import { District } from '../interface/district';
import { State } from '../interface/state';

import { HomeService } from './home.service';
import { ViewChild } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { SessionStorageService } from 'angular-web-storage';


@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  formData: FormData | null = null;

  preSignedUrl: string | null = null;
  errorMessage: string | null = null;

  constructor(private homeService: HomeService, private sessionStorage: SessionStorageService) {
  }
  fileUploadSuccess = false;
  fileName = '';

  ngOnInit(): void {
  }

  onFileSelected(event) {

    const file: File = event.target.files[0];

    if (file) {

      this.fileName = file.name;
      const formData = new FormData();
      formData.append("file", file);
      this.formData = formData;
    }
  }

  uploadFile() {
    this.fileUploadSuccess = false;
    this.homeService.uploadFile(this.formData!).then((data) => {
      this.formData = null;
      this.fileUploadSuccess = true;
      this.sessionStorage.set("fileName", data);
      const fileName = this.sessionStorage.get("fileName");
      console.log(fileName);
    }, error => {
      this.errorMessage = error.error;
    });
  }

  generatePDF() {
    const formData = new FormData();
    formData.append("imageName", this.sessionStorage.get("fileName"));
    this.homeService.generatePDF(formData).then((data) => {
      this.sessionStorage.remove("fileName");
      this.fileUploadSuccess = false;
      this.preSignedUrl = data;
    }, error => {
      this.errorMessage = error.error;
    });
  }

  clearSessionData() {
    this.preSignedUrl = null;
  }

}
