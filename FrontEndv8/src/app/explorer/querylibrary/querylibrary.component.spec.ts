import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { QueryLibraryComponent } from './querylibrary.component';

describe('QueryLibraryComponent', () => {
  let component: QueryLibraryComponent;
  let fixture: ComponentFixture<QueryLibraryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ QueryLibraryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(QueryLibraryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
