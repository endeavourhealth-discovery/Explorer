import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {CovidViewerComponent} from './covidviewer.component';

describe('CovidViewerComponent', () => {
  let component: CovidViewerComponent;
  let fixture: ComponentFixture<CovidViewerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CovidViewerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CovidViewerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
