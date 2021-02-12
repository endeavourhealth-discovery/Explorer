import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistryListsComponent } from './registrylists.component';

describe('RegistryListsComponent', () => {
  let component: RegistryListsComponent;
  let fixture: ComponentFixture<RegistryListsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RegistryListsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RegistryListsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
