import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AdvancedQueryEditorComponent } from './advancedqueryeditor.component';

describe('PatientComponent', () => {
  let component: AdvancedQueryEditorComponent;
  let fixture: ComponentFixture<AdvancedQueryEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AdvancedQueryEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AdvancedQueryEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
