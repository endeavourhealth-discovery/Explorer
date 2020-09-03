import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { OrganisationsEditorComponent } from './organisationseditor.component';

describe('OrganisationsEditorComponent', () => {
  let component: OrganisationsEditorComponent;
  let fixture: ComponentFixture<OrganisationsEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OrganisationsEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OrganisationsEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
