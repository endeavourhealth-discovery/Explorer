import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { OrganisationGroupsComponent } from './organisationgroups.component';

describe('OrganisationGroupsComponent', () => {
  let component: OrganisationGroupsComponent;
  let fixture: ComponentFixture<OrganisationGroupsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OrganisationGroupsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OrganisationGroupsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
