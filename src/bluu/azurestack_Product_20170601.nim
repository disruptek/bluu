
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AzureStack Azure Bridge Client
## version: 2017-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  macServiceName = "azurestack-Product"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProductsList_574679 = ref object of OpenApiRestCall_574457
proc url_ProductsList_574681(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsList_574680(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of products.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_574841 = path.getOrDefault("registrationName")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "registrationName", valid_574841
  var valid_574842 = path.getOrDefault("subscriptionId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "subscriptionId", valid_574842
  var valid_574843 = path.getOrDefault("resourceGroup")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "resourceGroup", valid_574843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574857 = query.getOrDefault("api-version")
  valid_574857 = validateParameter(valid_574857, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_574857 != nil:
    section.add "api-version", valid_574857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574884: Call_ProductsList_574679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of products.
  ## 
  let valid = call_574884.validator(path, query, header, formData, body)
  let scheme = call_574884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574884.url(scheme.get, call_574884.host, call_574884.base,
                         call_574884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574884, url, valid)

proc call*(call_574955: Call_ProductsList_574679; registrationName: string;
          subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## productsList
  ## Returns a list of products.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_574956 = newJObject()
  var query_574958 = newJObject()
  add(query_574958, "api-version", newJString(apiVersion))
  add(path_574956, "registrationName", newJString(registrationName))
  add(path_574956, "subscriptionId", newJString(subscriptionId))
  add(path_574956, "resourceGroup", newJString(resourceGroup))
  result = call_574955.call(path_574956, query_574958, nil, nil, nil)

var productsList* = Call_ProductsList_574679(name: "productsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/products",
    validator: validate_ProductsList_574680, base: "", url: url_ProductsList_574681,
    schemes: {Scheme.Https})
type
  Call_ProductsGet_574997 = ref object of OpenApiRestCall_574457
proc url_ProductsGet_574999(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsGet_574998(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Name of the product.
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575009 = path.getOrDefault("productName")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "productName", valid_575009
  var valid_575010 = path.getOrDefault("registrationName")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "registrationName", valid_575010
  var valid_575011 = path.getOrDefault("subscriptionId")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "subscriptionId", valid_575011
  var valid_575012 = path.getOrDefault("resourceGroup")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "resourceGroup", valid_575012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575013 = query.getOrDefault("api-version")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575013 != nil:
    section.add "api-version", valid_575013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575014: Call_ProductsGet_574997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified product.
  ## 
  let valid = call_575014.validator(path, query, header, formData, body)
  let scheme = call_575014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575014.url(scheme.get, call_575014.host, call_575014.base,
                         call_575014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575014, url, valid)

proc call*(call_575015: Call_ProductsGet_574997; productName: string;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## productsGet
  ## Returns the specified product.
  ##   productName: string (required)
  ##              : Name of the product.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_575016 = newJObject()
  var query_575017 = newJObject()
  add(path_575016, "productName", newJString(productName))
  add(query_575017, "api-version", newJString(apiVersion))
  add(path_575016, "registrationName", newJString(registrationName))
  add(path_575016, "subscriptionId", newJString(subscriptionId))
  add(path_575016, "resourceGroup", newJString(resourceGroup))
  result = call_575015.call(path_575016, query_575017, nil, nil, nil)

var productsGet* = Call_ProductsGet_574997(name: "productsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/products/{productName}",
                                        validator: validate_ProductsGet_574998,
                                        base: "", url: url_ProductsGet_574999,
                                        schemes: {Scheme.Https})
type
  Call_ProductsListDetails_575018 = ref object of OpenApiRestCall_574457
proc url_ProductsListDetails_575020(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/listDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListDetails_575019(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns the extended properties of a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Name of the product.
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575021 = path.getOrDefault("productName")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "productName", valid_575021
  var valid_575022 = path.getOrDefault("registrationName")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "registrationName", valid_575022
  var valid_575023 = path.getOrDefault("subscriptionId")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "subscriptionId", valid_575023
  var valid_575024 = path.getOrDefault("resourceGroup")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "resourceGroup", valid_575024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575025 = query.getOrDefault("api-version")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575025 != nil:
    section.add "api-version", valid_575025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575026: Call_ProductsListDetails_575018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the extended properties of a product.
  ## 
  let valid = call_575026.validator(path, query, header, formData, body)
  let scheme = call_575026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575026.url(scheme.get, call_575026.host, call_575026.base,
                         call_575026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575026, url, valid)

proc call*(call_575027: Call_ProductsListDetails_575018; productName: string;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## productsListDetails
  ## Returns the extended properties of a product.
  ##   productName: string (required)
  ##              : Name of the product.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_575028 = newJObject()
  var query_575029 = newJObject()
  add(path_575028, "productName", newJString(productName))
  add(query_575029, "api-version", newJString(apiVersion))
  add(path_575028, "registrationName", newJString(registrationName))
  add(path_575028, "subscriptionId", newJString(subscriptionId))
  add(path_575028, "resourceGroup", newJString(resourceGroup))
  result = call_575027.call(path_575028, query_575029, nil, nil, nil)

var productsListDetails* = Call_ProductsListDetails_575018(
    name: "productsListDetails", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/products/{productName}/listDetails",
    validator: validate_ProductsListDetails_575019, base: "",
    url: url_ProductsListDetails_575020, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
