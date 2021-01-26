import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CovidlibraryComponent } from './covidlibrary.component';

describe('CovidLibraryComponent', () => {
  let component: CovidlibraryComponent;
  let fixture: ComponentFixture<CovidlibraryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CovidlibraryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CovidlibraryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
