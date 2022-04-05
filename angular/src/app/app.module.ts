import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { MaterialModule } from './material/material.module';
import { HomeComponent } from './home/home.component'; 
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { HomeService } from './home/home.service';
import { Constants } from './constants/constants';
import { FlexLayoutModule } from '@angular/flex-layout';
import { FormsModule } from '@angular/forms';
import { LoadingImageInterceptor } from './common/loading-image.interceptor';
import { AppService } from './app.service';
import { AngularWebStorageModule } from 'angular-web-storage';


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MaterialModule,
    HttpClientModule,
    FlexLayoutModule,
    FormsModule,
    AngularWebStorageModule
  ],
  providers: [HomeService, Constants, AppService
    ,{
      provide: HTTP_INTERCEPTORS,
      useClass: LoadingImageInterceptor,
      multi: true,
      deps: [
          AppService
      ]
  }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
