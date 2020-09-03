import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { OrganisationGroupsCodeEditorComponent } from './organisationgroupscodeeditor.component';

describe('ValueSetCodeEditorComponent', () => {
  let component: OrganisationGroupsCodeEditorComponent;
  let fixture: ComponentFixture<OrganisationGroupsCodeEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OrganisationGroupsCodeEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OrganisationGroupsCodeEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
