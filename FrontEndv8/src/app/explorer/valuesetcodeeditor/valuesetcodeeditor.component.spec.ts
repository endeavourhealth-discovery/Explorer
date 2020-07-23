import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ValueSetCodeEditorComponent } from './valuesetcodeeditor.component';

describe('ValueSetCodeEditorComponent', () => {
  let component: ValueSetCodeEditorComponent;
  let fixture: ComponentFixture<ValueSetCodeEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValueSetCodeEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValueSetCodeEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
