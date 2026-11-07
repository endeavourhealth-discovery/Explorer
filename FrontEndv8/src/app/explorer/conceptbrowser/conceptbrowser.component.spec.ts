import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {ConceptBrowserComponent} from "./conceptbrowser.component";

describe('ConceptBrowserComponent', () => {
  let component: ConceptBrowserComponent;
  let fixture: ComponentFixture<ConceptBrowserComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ConceptBrowserComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ConceptBrowserComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
