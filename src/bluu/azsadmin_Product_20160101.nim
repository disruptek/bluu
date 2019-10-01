
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AzureBridgeAdminClient
## version: 2016-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## AzureBridge Admin Client.
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
  macServiceName = "azsadmin-Product"
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
  assert "activationName" in path, "`activationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsList_574680(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Return product name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activationName` field"
  var valid_574841 = path.getOrDefault("activationName")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "activationName", valid_574841
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
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574857 = query.getOrDefault("api-version")
  valid_574857 = validateParameter(valid_574857, JString, required = true,
                                 default = newJString("2016-01-01"))
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
  ## Return product name.
  ## 
  let valid = call_574884.validator(path, query, header, formData, body)
  let scheme = call_574884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574884.url(scheme.get, call_574884.host, call_574884.base,
                         call_574884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574884, url, valid)

proc call*(call_574955: Call_ProductsList_574679; activationName: string;
          subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## productsList
  ## Return product name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_574956 = newJObject()
  var query_574958 = newJObject()
  add(query_574958, "api-version", newJString(apiVersion))
  add(path_574956, "activationName", newJString(activationName))
  add(path_574956, "subscriptionId", newJString(subscriptionId))
  add(path_574956, "resourceGroup", newJString(resourceGroup))
  result = call_574955.call(path_574956, query_574958, nil, nil, nil)

var productsList* = Call_ProductsList_574679(name: "productsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}/products",
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
  assert "activationName" in path, "`activationName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsGet_574998(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Return product name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Name of the product.
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575000 = path.getOrDefault("productName")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "productName", valid_575000
  var valid_575001 = path.getOrDefault("activationName")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "activationName", valid_575001
  var valid_575002 = path.getOrDefault("subscriptionId")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "subscriptionId", valid_575002
  var valid_575003 = path.getOrDefault("resourceGroup")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "resourceGroup", valid_575003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575004 = query.getOrDefault("api-version")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_575004 != nil:
    section.add "api-version", valid_575004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575005: Call_ProductsGet_574997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return product name.
  ## 
  let valid = call_575005.validator(path, query, header, formData, body)
  let scheme = call_575005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575005.url(scheme.get, call_575005.host, call_575005.base,
                         call_575005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575005, url, valid)

proc call*(call_575006: Call_ProductsGet_574997; productName: string;
          activationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## productsGet
  ## Return product name.
  ##   productName: string (required)
  ##              : Name of the product.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_575007 = newJObject()
  var query_575008 = newJObject()
  add(path_575007, "productName", newJString(productName))
  add(query_575008, "api-version", newJString(apiVersion))
  add(path_575007, "activationName", newJString(activationName))
  add(path_575007, "subscriptionId", newJString(subscriptionId))
  add(path_575007, "resourceGroup", newJString(resourceGroup))
  result = call_575006.call(path_575007, query_575008, nil, nil, nil)

var productsGet* = Call_ProductsGet_574997(name: "productsGet",
                                        meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}/products/{productName}",
                                        validator: validate_ProductsGet_574998,
                                        base: "", url: url_ProductsGet_574999,
                                        schemes: {Scheme.Https})
type
  Call_ProductsDownload_575009 = ref object of OpenApiRestCall_574457
proc url_ProductsDownload_575011(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "activationName" in path, "`activationName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsDownload_575010(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Downloads a product from azure marketplace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Name of the product.
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575012 = path.getOrDefault("productName")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "productName", valid_575012
  var valid_575013 = path.getOrDefault("activationName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "activationName", valid_575013
  var valid_575014 = path.getOrDefault("subscriptionId")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "subscriptionId", valid_575014
  var valid_575015 = path.getOrDefault("resourceGroup")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "resourceGroup", valid_575015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575016 = query.getOrDefault("api-version")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_575016 != nil:
    section.add "api-version", valid_575016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575017: Call_ProductsDownload_575009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads a product from azure marketplace.
  ## 
  let valid = call_575017.validator(path, query, header, formData, body)
  let scheme = call_575017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575017.url(scheme.get, call_575017.host, call_575017.base,
                         call_575017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575017, url, valid)

proc call*(call_575018: Call_ProductsDownload_575009; productName: string;
          activationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## productsDownload
  ## Downloads a product from azure marketplace.
  ##   productName: string (required)
  ##              : Name of the product.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_575019 = newJObject()
  var query_575020 = newJObject()
  add(path_575019, "productName", newJString(productName))
  add(query_575020, "api-version", newJString(apiVersion))
  add(path_575019, "activationName", newJString(activationName))
  add(path_575019, "subscriptionId", newJString(subscriptionId))
  add(path_575019, "resourceGroup", newJString(resourceGroup))
  result = call_575018.call(path_575019, query_575020, nil, nil, nil)

var productsDownload* = Call_ProductsDownload_575009(name: "productsDownload",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}/products/{productName}/download",
    validator: validate_ProductsDownload_575010, base: "",
    url: url_ProductsDownload_575011, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
