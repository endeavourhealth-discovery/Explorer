import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {ValueSetCodeComponent} from "./valuesetcode.component";

describe('ValueSetCodeComponent', () => {
  let component: ValueSetCodeComponent;
  let fixture: ComponentFixture<ValueSetCodeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValueSetCodeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValueSetCodeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
