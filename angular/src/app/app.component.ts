import { Component, DoCheck } from '@angular/core';
import { Router } from '@angular/router';
import { AppService } from './app.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements DoCheck {
  title = 'image2pdf';
  isLoggedIn = false;
  showSpinner = false;

  constructor(private appService: AppService, private router: Router) {

    this.router.events.subscribe((event) => {
      this.appService.showSpinner = false;
    });

  }

  ngDoCheck(): void {
    this.showSpinner = this.appService.showSpinner;
  }
}
