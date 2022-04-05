import { Observable } from 'rxjs';
import { tap } from 'rxjs/internal/operators';
import { throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest, HttpResponse } from '@angular/common/http';
import { AppService } from '../app.service';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';

export class LoadingImageInterceptor implements HttpInterceptor {

    constructor(private appService: AppService) {

    }

    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        this.appService.showSpinner = true;
        return next.handle(req)
            .map((event: HttpEvent<any>) => {
                if (event instanceof HttpResponse) {
                    this.appService.showSpinner = false;
                    console.info('HttpResponse::event =', event, ';');
                } else {
                    console.info('event =', event, ';');
                }
                return event;
            });
    }



}
