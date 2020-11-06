import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { OrganisationlistsizesComponent } from './organisationlistsizes.component';

describe('OrganisationlistsizesComponent', () => {
  let component: OrganisationlistsizesComponent;
  let fixture: ComponentFixture<OrganisationlistsizesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OrganisationlistsizesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OrganisationlistsizesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
