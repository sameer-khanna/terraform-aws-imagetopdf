import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AppService {
  showSpinner: boolean = false;

  constructor() { }
}
