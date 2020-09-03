import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { OrganisationGroupsEditorComponent } from './organisationgroupseditor.component';

describe('ValueSetEditorComponent', () => {
  let component: OrganisationGroupsEditorComponent;
  let fixture: ComponentFixture<OrganisationGroupsEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OrganisationGroupsEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OrganisationGroupsEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
