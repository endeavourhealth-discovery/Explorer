import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistryEditorComponent } from './registryeditor.component';

describe('RegistryEditorComponent', () => {
  let component: RegistryEditorComponent;
  let fixture: ComponentFixture<RegistryEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RegistryEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RegistryEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
