
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Product entity associated with your Azure API Management deployment. The Product entity represents a product in API Management. Products include one or more APIs and their associated terms of use. Once a product is published, developers can subscribe to the product and begin to use the product’s APIs.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "apimanagement-apimproducts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProductList_593646 = ref object of OpenApiRestCall_593424
proc url_ProductList_593648(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProductList_593647(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of products in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   expandGroups: JBool
  ##               : When set to true, the response contains an array of groups that have visibility to the product. The default is false.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | terms       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state       | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593795 = query.getOrDefault("api-version")
  valid_593795 = validateParameter(valid_593795, JString, required = true,
                                 default = nil)
  if valid_593795 != nil:
    section.add "api-version", valid_593795
  var valid_593796 = query.getOrDefault("$top")
  valid_593796 = validateParameter(valid_593796, JInt, required = false, default = nil)
  if valid_593796 != nil:
    section.add "$top", valid_593796
  var valid_593797 = query.getOrDefault("$skip")
  valid_593797 = validateParameter(valid_593797, JInt, required = false, default = nil)
  if valid_593797 != nil:
    section.add "$skip", valid_593797
  var valid_593798 = query.getOrDefault("expandGroups")
  valid_593798 = validateParameter(valid_593798, JBool, required = false, default = nil)
  if valid_593798 != nil:
    section.add "expandGroups", valid_593798
  var valid_593799 = query.getOrDefault("$filter")
  valid_593799 = validateParameter(valid_593799, JString, required = false,
                                 default = nil)
  if valid_593799 != nil:
    section.add "$filter", valid_593799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593826: Call_ProductList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of products in the specified service instance.
  ## 
  let valid = call_593826.validator(path, query, header, formData, body)
  let scheme = call_593826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593826.url(scheme.get, call_593826.host, call_593826.base,
                         call_593826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593826, url, valid)

proc call*(call_593897: Call_ProductList_593646; apiVersion: string; Top: int = 0;
          Skip: int = 0; expandGroups: bool = false; Filter: string = ""): Recallable =
  ## productList
  ## Lists a collection of products in the specified service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   expandGroups: bool
  ##               : When set to true, the response contains an array of groups that have visibility to the product. The default is false.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | terms       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state       | eq                     |                                             |
  var query_593898 = newJObject()
  add(query_593898, "api-version", newJString(apiVersion))
  add(query_593898, "$top", newJInt(Top))
  add(query_593898, "$skip", newJInt(Skip))
  add(query_593898, "expandGroups", newJBool(expandGroups))
  add(query_593898, "$filter", newJString(Filter))
  result = call_593897.call(nil, query_593898, nil, nil, nil)

var productList* = Call_ProductList_593646(name: "productList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/products",
                                        validator: validate_ProductList_593647,
                                        base: "", url: url_ProductList_593648,
                                        schemes: {Scheme.Https})
type
  Call_ProductCreateOrUpdate_593970 = ref object of OpenApiRestCall_593424
proc url_ProductCreateOrUpdate_593972(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductCreateOrUpdate_593971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_593990 = path.getOrDefault("productId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "productId", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ProductCreateOrUpdate_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a product.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ProductCreateOrUpdate_593970; apiVersion: string;
          parameters: JsonNode; productId: string): Recallable =
  ## productCreateOrUpdate
  ## Creates or Updates a product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  var body_593997 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593997 = parameters
  add(path_593995, "productId", newJString(productId))
  result = call_593994.call(path_593995, query_593996, nil, nil, body_593997)

var productCreateOrUpdate* = Call_ProductCreateOrUpdate_593970(
    name: "productCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/products/{productId}", validator: validate_ProductCreateOrUpdate_593971,
    base: "", url: url_ProductCreateOrUpdate_593972, schemes: {Scheme.Https})
type
  Call_ProductGet_593938 = ref object of OpenApiRestCall_593424
proc url_ProductGet_593940(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGet_593939(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the product specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_593964 = path.getOrDefault("productId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "productId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_ProductGet_593938; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the product specified by its identifier.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_ProductGet_593938; apiVersion: string; productId: string): Recallable =
  ## productGet
  ## Gets the details of the product specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "productId", newJString(productId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var productGet* = Call_ProductGet_593938(name: "productGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/products/{productId}",
                                      validator: validate_ProductGet_593939,
                                      base: "", url: url_ProductGet_593940,
                                      schemes: {Scheme.Https})
type
  Call_ProductUpdate_594009 = ref object of OpenApiRestCall_593424
proc url_ProductUpdate_594011(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductUpdate_594010(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_594022 = path.getOrDefault("productId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "productId", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Product Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594024 = header.getOrDefault("If-Match")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "If-Match", valid_594024
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_ProductUpdate_594009; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update product.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_ProductUpdate_594009; apiVersion: string;
          parameters: JsonNode; productId: string): Recallable =
  ## productUpdate
  ## Update product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  var body_594030 = newJObject()
  add(query_594029, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594030 = parameters
  add(path_594028, "productId", newJString(productId))
  result = call_594027.call(path_594028, query_594029, nil, nil, body_594030)

var productUpdate* = Call_ProductUpdate_594009(name: "productUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/products/{productId}",
    validator: validate_ProductUpdate_594010, base: "", url: url_ProductUpdate_594011,
    schemes: {Scheme.Https})
type
  Call_ProductDelete_593998 = ref object of OpenApiRestCall_593424
proc url_ProductDelete_594000(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductDelete_593999(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_594001 = path.getOrDefault("productId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "productId", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Delete existing subscriptions to the product or not.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  var valid_594003 = query.getOrDefault("deleteSubscriptions")
  valid_594003 = validateParameter(valid_594003, JBool, required = false, default = nil)
  if valid_594003 != nil:
    section.add "deleteSubscriptions", valid_594003
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Product Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594004 = header.getOrDefault("If-Match")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "If-Match", valid_594004
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_ProductDelete_593998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete product.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_ProductDelete_593998; apiVersion: string;
          productId: string; deleteSubscriptions: bool = false): Recallable =
  ## productDelete
  ## Delete product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   deleteSubscriptions: bool
  ##                      : Delete existing subscriptions to the product or not.
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "productId", newJString(productId))
  add(query_594008, "deleteSubscriptions", newJBool(deleteSubscriptions))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var productDelete* = Call_ProductDelete_593998(name: "productDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/products/{productId}", validator: validate_ProductDelete_593999,
    base: "", url: url_ProductDelete_594000, schemes: {Scheme.Https})
type
  Call_ProductApiListByProduct_594031 = ref object of OpenApiRestCall_593424
proc url_ProductApiListByProduct_594033(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApiListByProduct_594032(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the APIs associated with a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_594034 = path.getOrDefault("productId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "productId", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  var valid_594036 = query.getOrDefault("$top")
  valid_594036 = validateParameter(valid_594036, JInt, required = false, default = nil)
  if valid_594036 != nil:
    section.add "$top", valid_594036
  var valid_594037 = query.getOrDefault("$skip")
  valid_594037 = validateParameter(valid_594037, JInt, required = false, default = nil)
  if valid_594037 != nil:
    section.add "$skip", valid_594037
  var valid_594038 = query.getOrDefault("$filter")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "$filter", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_ProductApiListByProduct_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the APIs associated with a product.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_ProductApiListByProduct_594031; apiVersion: string;
          productId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## productApiListByProduct
  ## Lists a collection of the APIs associated with a product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## 
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(query_594042, "api-version", newJString(apiVersion))
  add(query_594042, "$top", newJInt(Top))
  add(query_594042, "$skip", newJInt(Skip))
  add(path_594041, "productId", newJString(productId))
  add(query_594042, "$filter", newJString(Filter))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var productApiListByProduct* = Call_ProductApiListByProduct_594031(
    name: "productApiListByProduct", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/products/{productId}/apis",
    validator: validate_ProductApiListByProduct_594032, base: "",
    url: url_ProductApiListByProduct_594033, schemes: {Scheme.Https})
type
  Call_ProductApiCreateOrUpdate_594043 = ref object of OpenApiRestCall_593424
proc url_ProductApiCreateOrUpdate_594045(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApiCreateOrUpdate_594044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds an API to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_594046 = path.getOrDefault("apiId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "apiId", valid_594046
  var valid_594047 = path.getOrDefault("productId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "productId", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_ProductApiCreateOrUpdate_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an API to the specified product.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_ProductApiCreateOrUpdate_594043; apiVersion: string;
          apiId: string; productId: string): Recallable =
  ## productApiCreateOrUpdate
  ## Adds an API to the specified product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "apiId", newJString(apiId))
  add(path_594051, "productId", newJString(productId))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var productApiCreateOrUpdate* = Call_ProductApiCreateOrUpdate_594043(
    name: "productApiCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiCreateOrUpdate_594044, base: "",
    url: url_ProductApiCreateOrUpdate_594045, schemes: {Scheme.Https})
type
  Call_ProductApiDelete_594053 = ref object of OpenApiRestCall_593424
proc url_ProductApiDelete_594055(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApiDelete_594054(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the specified API from the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_594056 = path.getOrDefault("apiId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "apiId", valid_594056
  var valid_594057 = path.getOrDefault("productId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "productId", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_ProductApiDelete_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API from the specified product.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_ProductApiDelete_594053; apiVersion: string;
          apiId: string; productId: string): Recallable =
  ## productApiDelete
  ## Deletes the specified API from the specified product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "apiId", newJString(apiId))
  add(path_594061, "productId", newJString(productId))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var productApiDelete* = Call_ProductApiDelete_594053(name: "productApiDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiDelete_594054, base: "",
    url: url_ProductApiDelete_594055, schemes: {Scheme.Https})
type
  Call_ProductGroupListByProduct_594063 = ref object of OpenApiRestCall_593424
proc url_ProductGroupListByProduct_594065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupListByProduct_594064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_594066 = path.getOrDefault("productId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "productId", valid_594066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594067 = query.getOrDefault("api-version")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "api-version", valid_594067
  var valid_594068 = query.getOrDefault("$top")
  valid_594068 = validateParameter(valid_594068, JInt, required = false, default = nil)
  if valid_594068 != nil:
    section.add "$top", valid_594068
  var valid_594069 = query.getOrDefault("$skip")
  valid_594069 = validateParameter(valid_594069, JInt, required = false, default = nil)
  if valid_594069 != nil:
    section.add "$skip", valid_594069
  var valid_594070 = query.getOrDefault("$filter")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "$filter", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_ProductGroupListByProduct_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_ProductGroupListByProduct_594063; apiVersion: string;
          productId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## productGroupListByProduct
  ## Lists the collection of developer groups associated with the specified product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(query_594074, "api-version", newJString(apiVersion))
  add(query_594074, "$top", newJInt(Top))
  add(query_594074, "$skip", newJInt(Skip))
  add(path_594073, "productId", newJString(productId))
  add(query_594074, "$filter", newJString(Filter))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var productGroupListByProduct* = Call_ProductGroupListByProduct_594063(
    name: "productGroupListByProduct", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/products/{productId}/groups",
    validator: validate_ProductGroupListByProduct_594064, base: "",
    url: url_ProductGroupListByProduct_594065, schemes: {Scheme.Https})
type
  Call_ProductGroupCreateOrUpdate_594075 = ref object of OpenApiRestCall_593424
proc url_ProductGroupCreateOrUpdate_594077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupCreateOrUpdate_594076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594078 = path.getOrDefault("groupId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "groupId", valid_594078
  var valid_594079 = path.getOrDefault("productId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "productId", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_ProductGroupCreateOrUpdate_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_ProductGroupCreateOrUpdate_594075; groupId: string;
          apiVersion: string; productId: string): Recallable =
  ## productGroupCreateOrUpdate
  ## Adds the association between the specified developer group with the specified product.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(path_594083, "groupId", newJString(groupId))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "productId", newJString(productId))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var productGroupCreateOrUpdate* = Call_ProductGroupCreateOrUpdate_594075(
    name: "productGroupCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupCreateOrUpdate_594076, base: "",
    url: url_ProductGroupCreateOrUpdate_594077, schemes: {Scheme.Https})
type
  Call_ProductGroupDelete_594085 = ref object of OpenApiRestCall_593424
proc url_ProductGroupDelete_594087(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupDelete_594086(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the association between the specified group and product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594088 = path.getOrDefault("groupId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "groupId", valid_594088
  var valid_594089 = path.getOrDefault("productId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "productId", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594090 = query.getOrDefault("api-version")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "api-version", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_ProductGroupDelete_594085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the association between the specified group and product.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_ProductGroupDelete_594085; groupId: string;
          apiVersion: string; productId: string): Recallable =
  ## productGroupDelete
  ## Deletes the association between the specified group and product.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(path_594093, "groupId", newJString(groupId))
  add(query_594094, "api-version", newJString(apiVersion))
  add(path_594093, "productId", newJString(productId))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var productGroupDelete* = Call_ProductGroupDelete_594085(
    name: "productGroupDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupDelete_594086, base: "",
    url: url_ProductGroupDelete_594087, schemes: {Scheme.Https})
type
  Call_ProductPolicyListByProduct_594095 = ref object of OpenApiRestCall_593424
proc url_ProductPolicyListByProduct_594097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyListByProduct_594096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the Product level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_594098 = path.getOrDefault("productId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "productId", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_ProductPolicyListByProduct_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_ProductPolicyListByProduct_594095; apiVersion: string;
          productId: string): Recallable =
  ## productPolicyListByProduct
  ## Get the policy configuration at the Product level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "productId", newJString(productId))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var productPolicyListByProduct* = Call_ProductPolicyListByProduct_594095(
    name: "productPolicyListByProduct", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/products/{productId}/policies",
    validator: validate_ProductPolicyListByProduct_594096, base: "",
    url: url_ProductPolicyListByProduct_594097, schemes: {Scheme.Https})
type
  Call_ProductPolicyCreateOrUpdate_594127 = ref object of OpenApiRestCall_593424
proc url_ProductPolicyCreateOrUpdate_594129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyCreateOrUpdate_594128(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyId` field"
  var valid_594130 = path.getOrDefault("policyId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = newJString("policy"))
  if valid_594130 != nil:
    section.add "policyId", valid_594130
  var valid_594131 = path.getOrDefault("productId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "productId", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_ProductPolicyCreateOrUpdate_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the Product.
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_ProductPolicyCreateOrUpdate_594127;
          apiVersion: string; parameters: JsonNode; productId: string;
          policyId: string = "policy"): Recallable =
  ## productPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the Product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  var body_594138 = newJObject()
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "policyId", newJString(policyId))
  if parameters != nil:
    body_594138 = parameters
  add(path_594136, "productId", newJString(productId))
  result = call_594135.call(path_594136, query_594137, nil, nil, body_594138)

var productPolicyCreateOrUpdate* = Call_ProductPolicyCreateOrUpdate_594127(
    name: "productPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyCreateOrUpdate_594128, base: "",
    url: url_ProductPolicyCreateOrUpdate_594129, schemes: {Scheme.Https})
type
  Call_ProductPolicyGet_594104 = ref object of OpenApiRestCall_593424
proc url_ProductPolicyGet_594106(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyGet_594105(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the policy configuration at the Product level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyId` field"
  var valid_594120 = path.getOrDefault("policyId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = newJString("policy"))
  if valid_594120 != nil:
    section.add "policyId", valid_594120
  var valid_594121 = path.getOrDefault("productId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "productId", valid_594121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594122 = query.getOrDefault("api-version")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "api-version", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_ProductPolicyGet_594104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_ProductPolicyGet_594104; apiVersion: string;
          productId: string; policyId: string = "policy"): Recallable =
  ## productPolicyGet
  ## Get the policy configuration at the Product level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "policyId", newJString(policyId))
  add(path_594125, "productId", newJString(productId))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var productPolicyGet* = Call_ProductPolicyGet_594104(name: "productPolicyGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyGet_594105, base: "",
    url: url_ProductPolicyGet_594106, schemes: {Scheme.Https})
type
  Call_ProductPolicyDelete_594139 = ref object of OpenApiRestCall_593424
proc url_ProductPolicyDelete_594141(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyDelete_594140(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyId` field"
  var valid_594142 = path.getOrDefault("policyId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = newJString("policy"))
  if valid_594142 != nil:
    section.add "policyId", valid_594142
  var valid_594143 = path.getOrDefault("productId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "productId", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the product policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594145 = header.getOrDefault("If-Match")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "If-Match", valid_594145
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_ProductPolicyDelete_594139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Product.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_ProductPolicyDelete_594139; apiVersion: string;
          productId: string; policyId: string = "policy"): Recallable =
  ## productPolicyDelete
  ## Deletes the policy configuration at the Product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "policyId", newJString(policyId))
  add(path_594148, "productId", newJString(productId))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var productPolicyDelete* = Call_ProductPolicyDelete_594139(
    name: "productPolicyDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyDelete_594140, base: "",
    url: url_ProductPolicyDelete_594141, schemes: {Scheme.Https})
type
  Call_ProductSubscriptionsList_594150 = ref object of OpenApiRestCall_593424
proc url_ProductSubscriptionsList_594152(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductSubscriptionsList_594151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_594153 = path.getOrDefault("productId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "productId", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594154 = query.getOrDefault("api-version")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "api-version", valid_594154
  var valid_594155 = query.getOrDefault("$top")
  valid_594155 = validateParameter(valid_594155, JInt, required = false, default = nil)
  if valid_594155 != nil:
    section.add "$top", valid_594155
  var valid_594156 = query.getOrDefault("$skip")
  valid_594156 = validateParameter(valid_594156, JInt, required = false, default = nil)
  if valid_594156 != nil:
    section.add "$skip", valid_594156
  var valid_594157 = query.getOrDefault("$filter")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "$filter", valid_594157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594158: Call_ProductSubscriptionsList_594150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_ProductSubscriptionsList_594150; apiVersion: string;
          productId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## productSubscriptionsList
  ## Lists the collection of subscriptions to the specified product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  add(query_594161, "api-version", newJString(apiVersion))
  add(query_594161, "$top", newJInt(Top))
  add(query_594161, "$skip", newJInt(Skip))
  add(path_594160, "productId", newJString(productId))
  add(query_594161, "$filter", newJString(Filter))
  result = call_594159.call(path_594160, query_594161, nil, nil, nil)

var productSubscriptionsList* = Call_ProductSubscriptionsList_594150(
    name: "productSubscriptionsList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/products/{productId}/subscriptions",
    validator: validate_ProductSubscriptionsList_594151, base: "",
    url: url_ProductSubscriptionsList_594152, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
