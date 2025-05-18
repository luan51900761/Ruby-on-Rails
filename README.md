# Digital Assets Platform

A Rails application that enables creators to upload and sell digital assets, while allowing customers to purchase and download them.

## Project Overview

This platform provides a marketplace for digital assets with three user roles:
- **Creators**: Upload and sell digital assets
- **Customers**: Browse, purchase, and download digital assets
- **Admins**: Monitor platform metrics including creator earnings
# Run project
 - docker-compose up -d

## User
| User   | password | role     |
|--------|-------|----------|
| admin@example.com     | `password`    | admin    |
| creator1@example.com   | `password` | creator  |
| customer1@example.com | `password` | customer |
## API Reference & Routes

### Authentication Routes
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/login` | Display login form |
| POST   | `/login` | Authenticate user |
| DELETE | `/logout` | Log out current user |

### Asset Management (for Creators)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/assets` | List creator's assets |
| GET    | `/assets/bulk_import` | Display bulk import form |
| POST   | `/assets/process_bulk_import` | Process JSON file upload |

### Catalog (for Customers)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/catalog` | Browse all available assets |
| GET    | `/catalog/:id` | View asset details |

### Purchases (for Customers)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/purchases` | View purchase history |
| POST   | `/purchases` | Purchase an asset |

### Downloads (for Customers)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/downloads` | List purchased assets available for download |
| GET    | `/downloads/:id` | Download a purchased asset |

### Admin API
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/api/admin/creator_earnings` | Get JSON of all creators and their earnings |

## Usage Examples

### Bulk Import for Creators

1. Log in as a creator
2. Navigate to `/assets/bulk_import`
3. Prepare a JSON file with your assets (see format below)
4. Upload the file and submit

# Test Cases List for Digital Assets Platform
## Model Tests
### User Model
- **Valid User Testing**
    - Test a user is valid with complete attributes (email, password, role)
    - Test user creation with each valid role (customer, creator, admin)

- **Validation Testing**
    - Test user is invalid without an email
    - Test user is invalid with a duplicate email
    - Test user is invalid without a password
    - Test user is invalid with a password shorter than minimum length
    - Test user is invalid with an invalid role

- **Association Testing**
    - Test creator has many assets
    - Test customer has many purchases
    - Test customer has many purchased assets through purchases

- **Authentication Testing**
    - Test password hashing works correctly
    - Test authentication with correct credentials
    - Test authentication fails with incorrect credentials

### Asset Model
- **Valid Asset Testing**
    - Test asset is valid with complete attributes (title, file_url, price, user/creator)

- **Validation Testing**
    - Test asset is invalid without a title
    - Test asset is invalid without a file_url
    - Test asset is invalid with a negative price
    - Test asset is invalid without a creator
    - Test asset is invalid if user is not a creator

- **Association Testing**
    - Test asset belongs to a creator
    - Test asset has many purchases
    - Test asset has many customers through purchases

### Purchase Model
- **Valid Purchase Testing**
    - Test purchase is valid with complete attributes (user, asset, price_paid)

- **Validation Testing**
    - Test purchase is invalid without a user
    - Test purchase is invalid without an asset
    - Test purchase is invalid without a price_paid
    - Test unique constraint for user-asset combination (prevent duplicate purchases)

- **Association Testing**
    - Test purchase belongs to a user
    - Test purchase belongs to an asset

## Controller Tests
### Sessions Controller (Authentication)
- **Login Form (GET /login)**
    - Test login form displays correctly

- **Authentication (POST /login)**
    - Test successful login with valid credentials
    - Test failed login with invalid credentials
    - Test appropriate redirects after login

- **Logout (DELETE /logout)**
    - Test session is cleared on logout
    - Test appropriate redirects after logout

### Assets Controller (Creator Features)
- **Asset Listing (GET /assets)**
    - Test creators can view their assets
    - Test non-creators are redirected

- **Asset Creation (POST /assets)**
    - Test creators can create assets with valid attributes
    - Test validation errors are shown for invalid attributes
    - Test non-creators cannot create assets

- **Bulk Import Form (GET /assets/bulk_import)**
    - Test bulk import form displays correctly for creators
    - Test non-creators are redirected

- **Bulk Import Processing (POST /assets/process_bulk_import)**
    - Test successful import of valid JSON data
    - Test error handling for invalid JSON
    - Test non-creators cannot import assets

### Catalog Controller (Customer Features)
- **Browse Catalog (GET /catalog)**
    - Test all published assets are displayed
    - Test appropriate filtering and sorting options

- **Asset Details (GET /catalog/:id)**
    - Test asset details page shows correct information
    - Test purchase button appears for non-purchased assets
    - Test download button appears for purchased assets

### Purchases Controller
- **Purchase History (GET /purchases)**
    - Test customers can view their purchase history
    - Test non-customers are redirected

- **Make Purchase (POST /purchases)**
    - Test customers can purchase assets
    - Test price is recorded correctly
    - Test duplicate purchases are prevented
    - Test non-customers cannot make purchases

### Downloads Controller
- **Download List (GET /downloads)**
    - Test customers can view their downloadable assets
    - Test non-customers are redirected

- **Download Asset (GET /downloads/:id)**
    - Test customers can download purchased assets
    - Test customers cannot download non-purchased assets
    - Test non-customers cannot download assets

### Admin API Controller
- **Creator Earnings (GET /api/admin/creator_earnings)**
    - Test admin can view all creators' earnings
    - Test data format and structure is correct
    - Test non-admins cannot access this data

## Integration Tests
### User Workflows
- **Creator Workflow**
    - Test complete flow of creator signup
    - Test creator uploading a single asset
    - Test creator performing bulk import
    - Test creator viewing their earnings

- **Customer Workflow**
    - Test complete flow of customer signup
    - Test customer browsing the catalog
    - Test customer purchasing an asset
    - Test customer downloading a purchased asset

- **Admin Workflow**
    - Test admin monitoring platform metrics
    - Test admin accessing creator earnings report

### Error Handling
- Test handling of invalid data submissions
- Test handling of not found resources
- Test handling of unauthorized actions
### Security Tests
### Performance Tests

