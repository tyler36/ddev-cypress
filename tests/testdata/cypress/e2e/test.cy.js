describe('Example test', () => {
  it('Can read the site', () => {
    cy.visit('/')
    cy.contains('this is a test')
  })
})
