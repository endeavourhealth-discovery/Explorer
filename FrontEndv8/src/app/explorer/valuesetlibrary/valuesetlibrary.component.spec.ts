import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ValueSetLibraryComponent } from './valuesetlibrary.component';

describe('ValueSetLibraryComponent', () => {
  let component: ValueSetLibraryComponent;
  let fixture: ComponentFixture<ValueSetLibraryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValueSetLibraryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValueSetLibraryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
