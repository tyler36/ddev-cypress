describe('Example test', () => {
  it('Can read the site', () => {
    cy.visit('https://ddev-cypress.ddev.site')
    cy.contains('this is a test')
  })
})
