import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistryIndicatorEditorComponent } from './registryindicatoreditor.component';

describe('RegistryIndicatorEditorComponent', () => {
  let component: RegistryIndicatorEditorComponent;
  let fixture: ComponentFixture<RegistryIndicatorEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RegistryIndicatorEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RegistryIndicatorEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
