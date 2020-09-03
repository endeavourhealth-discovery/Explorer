import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {OrganisationGroupsCodeComponent} from "./organisationgroupscode.component";

describe('OrganisationGroupsCodeComponent', () => {
  let component: OrganisationGroupsCodeComponent;
  let fixture: ComponentFixture<OrganisationGroupsCodeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OrganisationGroupsCodeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OrganisationGroupsCodeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
