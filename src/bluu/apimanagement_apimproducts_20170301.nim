
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  Call_ProductListByService_573879 = ref object of OpenApiRestCall_573657
proc url_ProductListByService_573881(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductListByService_573880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of products in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574042 = path.getOrDefault("resourceGroupName")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "resourceGroupName", valid_574042
  var valid_574043 = path.getOrDefault("subscriptionId")
  valid_574043 = validateParameter(valid_574043, JString, required = true,
                                 default = nil)
  if valid_574043 != nil:
    section.add "subscriptionId", valid_574043
  var valid_574044 = path.getOrDefault("serviceName")
  valid_574044 = validateParameter(valid_574044, JString, required = true,
                                 default = nil)
  if valid_574044 != nil:
    section.add "serviceName", valid_574044
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
  var valid_574045 = query.getOrDefault("api-version")
  valid_574045 = validateParameter(valid_574045, JString, required = true,
                                 default = nil)
  if valid_574045 != nil:
    section.add "api-version", valid_574045
  var valid_574046 = query.getOrDefault("$top")
  valid_574046 = validateParameter(valid_574046, JInt, required = false, default = nil)
  if valid_574046 != nil:
    section.add "$top", valid_574046
  var valid_574047 = query.getOrDefault("$skip")
  valid_574047 = validateParameter(valid_574047, JInt, required = false, default = nil)
  if valid_574047 != nil:
    section.add "$skip", valid_574047
  var valid_574048 = query.getOrDefault("expandGroups")
  valid_574048 = validateParameter(valid_574048, JBool, required = false, default = nil)
  if valid_574048 != nil:
    section.add "expandGroups", valid_574048
  var valid_574049 = query.getOrDefault("$filter")
  valid_574049 = validateParameter(valid_574049, JString, required = false,
                                 default = nil)
  if valid_574049 != nil:
    section.add "$filter", valid_574049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574076: Call_ProductListByService_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of products in the specified service instance.
  ## 
  let valid = call_574076.validator(path, query, header, formData, body)
  let scheme = call_574076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574076.url(scheme.get, call_574076.host, call_574076.base,
                         call_574076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574076, url, valid)

proc call*(call_574147: Call_ProductListByService_573879;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; expandGroups: bool = false;
          Filter: string = ""): Recallable =
  ## productListByService
  ## Lists a collection of products in the specified service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   expandGroups: bool
  ##               : When set to true, the response contains an array of groups that have visibility to the product. The default is false.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | terms       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state       | eq                     |                                             |
  var path_574148 = newJObject()
  var query_574150 = newJObject()
  add(path_574148, "resourceGroupName", newJString(resourceGroupName))
  add(query_574150, "api-version", newJString(apiVersion))
  add(path_574148, "subscriptionId", newJString(subscriptionId))
  add(query_574150, "$top", newJInt(Top))
  add(query_574150, "$skip", newJInt(Skip))
  add(query_574150, "expandGroups", newJBool(expandGroups))
  add(path_574148, "serviceName", newJString(serviceName))
  add(query_574150, "$filter", newJString(Filter))
  result = call_574147.call(path_574148, query_574150, nil, nil, nil)

var productListByService* = Call_ProductListByService_573879(
    name: "productListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products",
    validator: validate_ProductListByService_573880, base: "",
    url: url_ProductListByService_573881, schemes: {Scheme.Https})
type
  Call_ProductCreateOrUpdate_574210 = ref object of OpenApiRestCall_573657
proc url_ProductCreateOrUpdate_574212(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductCreateOrUpdate_574211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574230 = path.getOrDefault("resourceGroupName")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "resourceGroupName", valid_574230
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
  var valid_574232 = path.getOrDefault("productId")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "productId", valid_574232
  var valid_574233 = path.getOrDefault("serviceName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "serviceName", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
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

proc call*(call_574236: Call_ProductCreateOrUpdate_574210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a product.
  ## 
  let valid = call_574236.validator(path, query, header, formData, body)
  let scheme = call_574236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574236.url(scheme.get, call_574236.host, call_574236.base,
                         call_574236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574236, url, valid)

proc call*(call_574237: Call_ProductCreateOrUpdate_574210;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; productId: string; serviceName: string): Recallable =
  ## productCreateOrUpdate
  ## Creates or Updates a product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574238 = newJObject()
  var query_574239 = newJObject()
  var body_574240 = newJObject()
  add(path_574238, "resourceGroupName", newJString(resourceGroupName))
  add(query_574239, "api-version", newJString(apiVersion))
  add(path_574238, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574240 = parameters
  add(path_574238, "productId", newJString(productId))
  add(path_574238, "serviceName", newJString(serviceName))
  result = call_574237.call(path_574238, query_574239, nil, nil, body_574240)

var productCreateOrUpdate* = Call_ProductCreateOrUpdate_574210(
    name: "productCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductCreateOrUpdate_574211, base: "",
    url: url_ProductCreateOrUpdate_574212, schemes: {Scheme.Https})
type
  Call_ProductGetEntityTag_574255 = ref object of OpenApiRestCall_573657
proc url_ProductGetEntityTag_574257(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGetEntityTag_574256(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the product specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574258 = path.getOrDefault("resourceGroupName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "resourceGroupName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  var valid_574260 = path.getOrDefault("productId")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "productId", valid_574260
  var valid_574261 = path.getOrDefault("serviceName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "serviceName", valid_574261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574262 = query.getOrDefault("api-version")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "api-version", valid_574262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574263: Call_ProductGetEntityTag_574255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the product specified by its identifier.
  ## 
  let valid = call_574263.validator(path, query, header, formData, body)
  let scheme = call_574263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574263.url(scheme.get, call_574263.host, call_574263.base,
                         call_574263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574263, url, valid)

proc call*(call_574264: Call_ProductGetEntityTag_574255; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string): Recallable =
  ## productGetEntityTag
  ## Gets the entity state (Etag) version of the product specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574265 = newJObject()
  var query_574266 = newJObject()
  add(path_574265, "resourceGroupName", newJString(resourceGroupName))
  add(query_574266, "api-version", newJString(apiVersion))
  add(path_574265, "subscriptionId", newJString(subscriptionId))
  add(path_574265, "productId", newJString(productId))
  add(path_574265, "serviceName", newJString(serviceName))
  result = call_574264.call(path_574265, query_574266, nil, nil, nil)

var productGetEntityTag* = Call_ProductGetEntityTag_574255(
    name: "productGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductGetEntityTag_574256, base: "",
    url: url_ProductGetEntityTag_574257, schemes: {Scheme.Https})
type
  Call_ProductGet_574189 = ref object of OpenApiRestCall_573657
proc url_ProductGet_574191(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGet_574190(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the product specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574201 = path.getOrDefault("resourceGroupName")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "resourceGroupName", valid_574201
  var valid_574202 = path.getOrDefault("subscriptionId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "subscriptionId", valid_574202
  var valid_574203 = path.getOrDefault("productId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "productId", valid_574203
  var valid_574204 = path.getOrDefault("serviceName")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "serviceName", valid_574204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574205 = query.getOrDefault("api-version")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "api-version", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_ProductGet_574189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the product specified by its identifier.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_ProductGet_574189; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string): Recallable =
  ## productGet
  ## Gets the details of the product specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574208 = newJObject()
  var query_574209 = newJObject()
  add(path_574208, "resourceGroupName", newJString(resourceGroupName))
  add(query_574209, "api-version", newJString(apiVersion))
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  add(path_574208, "productId", newJString(productId))
  add(path_574208, "serviceName", newJString(serviceName))
  result = call_574207.call(path_574208, query_574209, nil, nil, nil)

var productGet* = Call_ProductGet_574189(name: "productGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
                                      validator: validate_ProductGet_574190,
                                      base: "", url: url_ProductGet_574191,
                                      schemes: {Scheme.Https})
type
  Call_ProductUpdate_574267 = ref object of OpenApiRestCall_573657
proc url_ProductUpdate_574269(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductUpdate_574268(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574270 = path.getOrDefault("resourceGroupName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "resourceGroupName", valid_574270
  var valid_574271 = path.getOrDefault("subscriptionId")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "subscriptionId", valid_574271
  var valid_574272 = path.getOrDefault("productId")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "productId", valid_574272
  var valid_574273 = path.getOrDefault("serviceName")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "serviceName", valid_574273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574274 = query.getOrDefault("api-version")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "api-version", valid_574274
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Product Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574275 = header.getOrDefault("If-Match")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "If-Match", valid_574275
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

proc call*(call_574277: Call_ProductUpdate_574267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update product.
  ## 
  let valid = call_574277.validator(path, query, header, formData, body)
  let scheme = call_574277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574277.url(scheme.get, call_574277.host, call_574277.base,
                         call_574277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574277, url, valid)

proc call*(call_574278: Call_ProductUpdate_574267; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          productId: string; serviceName: string): Recallable =
  ## productUpdate
  ## Update product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574279 = newJObject()
  var query_574280 = newJObject()
  var body_574281 = newJObject()
  add(path_574279, "resourceGroupName", newJString(resourceGroupName))
  add(query_574280, "api-version", newJString(apiVersion))
  add(path_574279, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574281 = parameters
  add(path_574279, "productId", newJString(productId))
  add(path_574279, "serviceName", newJString(serviceName))
  result = call_574278.call(path_574279, query_574280, nil, nil, body_574281)

var productUpdate* = Call_ProductUpdate_574267(name: "productUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductUpdate_574268, base: "", url: url_ProductUpdate_574269,
    schemes: {Scheme.Https})
type
  Call_ProductDelete_574241 = ref object of OpenApiRestCall_573657
proc url_ProductDelete_574243(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductDelete_574242(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574244 = path.getOrDefault("resourceGroupName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "resourceGroupName", valid_574244
  var valid_574245 = path.getOrDefault("subscriptionId")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "subscriptionId", valid_574245
  var valid_574246 = path.getOrDefault("productId")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "productId", valid_574246
  var valid_574247 = path.getOrDefault("serviceName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "serviceName", valid_574247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Delete existing subscriptions to the product or not.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574248 = query.getOrDefault("api-version")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "api-version", valid_574248
  var valid_574249 = query.getOrDefault("deleteSubscriptions")
  valid_574249 = validateParameter(valid_574249, JBool, required = false, default = nil)
  if valid_574249 != nil:
    section.add "deleteSubscriptions", valid_574249
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Product Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574250 = header.getOrDefault("If-Match")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "If-Match", valid_574250
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574251: Call_ProductDelete_574241; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete product.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_ProductDelete_574241; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string; deleteSubscriptions: bool = false): Recallable =
  ## productDelete
  ## Delete product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   deleteSubscriptions: bool
  ##                      : Delete existing subscriptions to the product or not.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  add(path_574253, "resourceGroupName", newJString(resourceGroupName))
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  add(path_574253, "productId", newJString(productId))
  add(path_574253, "serviceName", newJString(serviceName))
  add(query_574254, "deleteSubscriptions", newJBool(deleteSubscriptions))
  result = call_574252.call(path_574253, query_574254, nil, nil, nil)

var productDelete* = Call_ProductDelete_574241(name: "productDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductDelete_574242, base: "", url: url_ProductDelete_574243,
    schemes: {Scheme.Https})
type
  Call_ProductApiListByProduct_574282 = ref object of OpenApiRestCall_573657
proc url_ProductApiListByProduct_574284(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApiListByProduct_574283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the APIs associated with a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574285 = path.getOrDefault("resourceGroupName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "resourceGroupName", valid_574285
  var valid_574286 = path.getOrDefault("subscriptionId")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "subscriptionId", valid_574286
  var valid_574287 = path.getOrDefault("productId")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "productId", valid_574287
  var valid_574288 = path.getOrDefault("serviceName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "serviceName", valid_574288
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
  var valid_574289 = query.getOrDefault("api-version")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "api-version", valid_574289
  var valid_574290 = query.getOrDefault("$top")
  valid_574290 = validateParameter(valid_574290, JInt, required = false, default = nil)
  if valid_574290 != nil:
    section.add "$top", valid_574290
  var valid_574291 = query.getOrDefault("$skip")
  valid_574291 = validateParameter(valid_574291, JInt, required = false, default = nil)
  if valid_574291 != nil:
    section.add "$skip", valid_574291
  var valid_574292 = query.getOrDefault("$filter")
  valid_574292 = validateParameter(valid_574292, JString, required = false,
                                 default = nil)
  if valid_574292 != nil:
    section.add "$filter", valid_574292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574293: Call_ProductApiListByProduct_574282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the APIs associated with a product.
  ## 
  let valid = call_574293.validator(path, query, header, formData, body)
  let scheme = call_574293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574293.url(scheme.get, call_574293.host, call_574293.base,
                         call_574293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574293, url, valid)

proc call*(call_574294: Call_ProductApiListByProduct_574282;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## productApiListByProduct
  ## Lists a collection of the APIs associated with a product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  var path_574295 = newJObject()
  var query_574296 = newJObject()
  add(path_574295, "resourceGroupName", newJString(resourceGroupName))
  add(query_574296, "api-version", newJString(apiVersion))
  add(path_574295, "subscriptionId", newJString(subscriptionId))
  add(query_574296, "$top", newJInt(Top))
  add(query_574296, "$skip", newJInt(Skip))
  add(path_574295, "productId", newJString(productId))
  add(path_574295, "serviceName", newJString(serviceName))
  add(query_574296, "$filter", newJString(Filter))
  result = call_574294.call(path_574295, query_574296, nil, nil, nil)

var productApiListByProduct* = Call_ProductApiListByProduct_574282(
    name: "productApiListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis",
    validator: validate_ProductApiListByProduct_574283, base: "",
    url: url_ProductApiListByProduct_574284, schemes: {Scheme.Https})
type
  Call_ProductApiCreateOrUpdate_574297 = ref object of OpenApiRestCall_573657
proc url_ProductApiCreateOrUpdate_574299(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApiCreateOrUpdate_574298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds an API to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574300 = path.getOrDefault("resourceGroupName")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "resourceGroupName", valid_574300
  var valid_574301 = path.getOrDefault("apiId")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "apiId", valid_574301
  var valid_574302 = path.getOrDefault("subscriptionId")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "subscriptionId", valid_574302
  var valid_574303 = path.getOrDefault("productId")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "productId", valid_574303
  var valid_574304 = path.getOrDefault("serviceName")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = nil)
  if valid_574304 != nil:
    section.add "serviceName", valid_574304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574305 = query.getOrDefault("api-version")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "api-version", valid_574305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574306: Call_ProductApiCreateOrUpdate_574297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an API to the specified product.
  ## 
  let valid = call_574306.validator(path, query, header, formData, body)
  let scheme = call_574306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574306.url(scheme.get, call_574306.host, call_574306.base,
                         call_574306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574306, url, valid)

proc call*(call_574307: Call_ProductApiCreateOrUpdate_574297;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; productId: string; serviceName: string): Recallable =
  ## productApiCreateOrUpdate
  ## Adds an API to the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574308 = newJObject()
  var query_574309 = newJObject()
  add(path_574308, "resourceGroupName", newJString(resourceGroupName))
  add(query_574309, "api-version", newJString(apiVersion))
  add(path_574308, "apiId", newJString(apiId))
  add(path_574308, "subscriptionId", newJString(subscriptionId))
  add(path_574308, "productId", newJString(productId))
  add(path_574308, "serviceName", newJString(serviceName))
  result = call_574307.call(path_574308, query_574309, nil, nil, nil)

var productApiCreateOrUpdate* = Call_ProductApiCreateOrUpdate_574297(
    name: "productApiCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiCreateOrUpdate_574298, base: "",
    url: url_ProductApiCreateOrUpdate_574299, schemes: {Scheme.Https})
type
  Call_ProductApiCheckEntityExists_574323 = ref object of OpenApiRestCall_573657
proc url_ProductApiCheckEntityExists_574325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApiCheckEntityExists_574324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that API entity specified by identifier is associated with the Product entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574326 = path.getOrDefault("resourceGroupName")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "resourceGroupName", valid_574326
  var valid_574327 = path.getOrDefault("apiId")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "apiId", valid_574327
  var valid_574328 = path.getOrDefault("subscriptionId")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "subscriptionId", valid_574328
  var valid_574329 = path.getOrDefault("productId")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "productId", valid_574329
  var valid_574330 = path.getOrDefault("serviceName")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "serviceName", valid_574330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574331 = query.getOrDefault("api-version")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "api-version", valid_574331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574332: Call_ProductApiCheckEntityExists_574323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that API entity specified by identifier is associated with the Product entity.
  ## 
  let valid = call_574332.validator(path, query, header, formData, body)
  let scheme = call_574332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574332.url(scheme.get, call_574332.host, call_574332.base,
                         call_574332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574332, url, valid)

proc call*(call_574333: Call_ProductApiCheckEntityExists_574323;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; productId: string; serviceName: string): Recallable =
  ## productApiCheckEntityExists
  ## Checks that API entity specified by identifier is associated with the Product entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574334 = newJObject()
  var query_574335 = newJObject()
  add(path_574334, "resourceGroupName", newJString(resourceGroupName))
  add(query_574335, "api-version", newJString(apiVersion))
  add(path_574334, "apiId", newJString(apiId))
  add(path_574334, "subscriptionId", newJString(subscriptionId))
  add(path_574334, "productId", newJString(productId))
  add(path_574334, "serviceName", newJString(serviceName))
  result = call_574333.call(path_574334, query_574335, nil, nil, nil)

var productApiCheckEntityExists* = Call_ProductApiCheckEntityExists_574323(
    name: "productApiCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiCheckEntityExists_574324, base: "",
    url: url_ProductApiCheckEntityExists_574325, schemes: {Scheme.Https})
type
  Call_ProductApiDelete_574310 = ref object of OpenApiRestCall_573657
proc url_ProductApiDelete_574312(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApiDelete_574311(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the specified API from the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574313 = path.getOrDefault("resourceGroupName")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "resourceGroupName", valid_574313
  var valid_574314 = path.getOrDefault("apiId")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "apiId", valid_574314
  var valid_574315 = path.getOrDefault("subscriptionId")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = nil)
  if valid_574315 != nil:
    section.add "subscriptionId", valid_574315
  var valid_574316 = path.getOrDefault("productId")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "productId", valid_574316
  var valid_574317 = path.getOrDefault("serviceName")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "serviceName", valid_574317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574318 = query.getOrDefault("api-version")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "api-version", valid_574318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574319: Call_ProductApiDelete_574310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API from the specified product.
  ## 
  let valid = call_574319.validator(path, query, header, formData, body)
  let scheme = call_574319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574319.url(scheme.get, call_574319.host, call_574319.base,
                         call_574319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574319, url, valid)

proc call*(call_574320: Call_ProductApiDelete_574310; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productApiDelete
  ## Deletes the specified API from the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574321 = newJObject()
  var query_574322 = newJObject()
  add(path_574321, "resourceGroupName", newJString(resourceGroupName))
  add(query_574322, "api-version", newJString(apiVersion))
  add(path_574321, "apiId", newJString(apiId))
  add(path_574321, "subscriptionId", newJString(subscriptionId))
  add(path_574321, "productId", newJString(productId))
  add(path_574321, "serviceName", newJString(serviceName))
  result = call_574320.call(path_574321, query_574322, nil, nil, nil)

var productApiDelete* = Call_ProductApiDelete_574310(name: "productApiDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiDelete_574311, base: "",
    url: url_ProductApiDelete_574312, schemes: {Scheme.Https})
type
  Call_ProductGroupListByProduct_574336 = ref object of OpenApiRestCall_573657
proc url_ProductGroupListByProduct_574338(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupListByProduct_574337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574339 = path.getOrDefault("resourceGroupName")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "resourceGroupName", valid_574339
  var valid_574340 = path.getOrDefault("subscriptionId")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "subscriptionId", valid_574340
  var valid_574341 = path.getOrDefault("productId")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = nil)
  if valid_574341 != nil:
    section.add "productId", valid_574341
  var valid_574342 = path.getOrDefault("serviceName")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "serviceName", valid_574342
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
  var valid_574343 = query.getOrDefault("api-version")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "api-version", valid_574343
  var valid_574344 = query.getOrDefault("$top")
  valid_574344 = validateParameter(valid_574344, JInt, required = false, default = nil)
  if valid_574344 != nil:
    section.add "$top", valid_574344
  var valid_574345 = query.getOrDefault("$skip")
  valid_574345 = validateParameter(valid_574345, JInt, required = false, default = nil)
  if valid_574345 != nil:
    section.add "$skip", valid_574345
  var valid_574346 = query.getOrDefault("$filter")
  valid_574346 = validateParameter(valid_574346, JString, required = false,
                                 default = nil)
  if valid_574346 != nil:
    section.add "$filter", valid_574346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574347: Call_ProductGroupListByProduct_574336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  let valid = call_574347.validator(path, query, header, formData, body)
  let scheme = call_574347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574347.url(scheme.get, call_574347.host, call_574347.base,
                         call_574347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574347, url, valid)

proc call*(call_574348: Call_ProductGroupListByProduct_574336;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## productGroupListByProduct
  ## Lists the collection of developer groups associated with the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  var path_574349 = newJObject()
  var query_574350 = newJObject()
  add(path_574349, "resourceGroupName", newJString(resourceGroupName))
  add(query_574350, "api-version", newJString(apiVersion))
  add(path_574349, "subscriptionId", newJString(subscriptionId))
  add(query_574350, "$top", newJInt(Top))
  add(query_574350, "$skip", newJInt(Skip))
  add(path_574349, "productId", newJString(productId))
  add(path_574349, "serviceName", newJString(serviceName))
  add(query_574350, "$filter", newJString(Filter))
  result = call_574348.call(path_574349, query_574350, nil, nil, nil)

var productGroupListByProduct* = Call_ProductGroupListByProduct_574336(
    name: "productGroupListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups",
    validator: validate_ProductGroupListByProduct_574337, base: "",
    url: url_ProductGroupListByProduct_574338, schemes: {Scheme.Https})
type
  Call_ProductGroupCreateOrUpdate_574351 = ref object of OpenApiRestCall_573657
proc url_ProductGroupCreateOrUpdate_574353(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupCreateOrUpdate_574352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574354 = path.getOrDefault("groupId")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "groupId", valid_574354
  var valid_574355 = path.getOrDefault("resourceGroupName")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "resourceGroupName", valid_574355
  var valid_574356 = path.getOrDefault("subscriptionId")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "subscriptionId", valid_574356
  var valid_574357 = path.getOrDefault("productId")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "productId", valid_574357
  var valid_574358 = path.getOrDefault("serviceName")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "serviceName", valid_574358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574359 = query.getOrDefault("api-version")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "api-version", valid_574359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574360: Call_ProductGroupCreateOrUpdate_574351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  let valid = call_574360.validator(path, query, header, formData, body)
  let scheme = call_574360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574360.url(scheme.get, call_574360.host, call_574360.base,
                         call_574360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574360, url, valid)

proc call*(call_574361: Call_ProductGroupCreateOrUpdate_574351; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productGroupCreateOrUpdate
  ## Adds the association between the specified developer group with the specified product.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574362 = newJObject()
  var query_574363 = newJObject()
  add(path_574362, "groupId", newJString(groupId))
  add(path_574362, "resourceGroupName", newJString(resourceGroupName))
  add(query_574363, "api-version", newJString(apiVersion))
  add(path_574362, "subscriptionId", newJString(subscriptionId))
  add(path_574362, "productId", newJString(productId))
  add(path_574362, "serviceName", newJString(serviceName))
  result = call_574361.call(path_574362, query_574363, nil, nil, nil)

var productGroupCreateOrUpdate* = Call_ProductGroupCreateOrUpdate_574351(
    name: "productGroupCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupCreateOrUpdate_574352, base: "",
    url: url_ProductGroupCreateOrUpdate_574353, schemes: {Scheme.Https})
type
  Call_ProductGroupCheckEntityExists_574377 = ref object of OpenApiRestCall_573657
proc url_ProductGroupCheckEntityExists_574379(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupCheckEntityExists_574378(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that Group entity specified by identifier is associated with the Product entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574380 = path.getOrDefault("groupId")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "groupId", valid_574380
  var valid_574381 = path.getOrDefault("resourceGroupName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "resourceGroupName", valid_574381
  var valid_574382 = path.getOrDefault("subscriptionId")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "subscriptionId", valid_574382
  var valid_574383 = path.getOrDefault("productId")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "productId", valid_574383
  var valid_574384 = path.getOrDefault("serviceName")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "serviceName", valid_574384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574385 = query.getOrDefault("api-version")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "api-version", valid_574385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574386: Call_ProductGroupCheckEntityExists_574377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that Group entity specified by identifier is associated with the Product entity.
  ## 
  let valid = call_574386.validator(path, query, header, formData, body)
  let scheme = call_574386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574386.url(scheme.get, call_574386.host, call_574386.base,
                         call_574386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574386, url, valid)

proc call*(call_574387: Call_ProductGroupCheckEntityExists_574377; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productGroupCheckEntityExists
  ## Checks that Group entity specified by identifier is associated with the Product entity.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574388 = newJObject()
  var query_574389 = newJObject()
  add(path_574388, "groupId", newJString(groupId))
  add(path_574388, "resourceGroupName", newJString(resourceGroupName))
  add(query_574389, "api-version", newJString(apiVersion))
  add(path_574388, "subscriptionId", newJString(subscriptionId))
  add(path_574388, "productId", newJString(productId))
  add(path_574388, "serviceName", newJString(serviceName))
  result = call_574387.call(path_574388, query_574389, nil, nil, nil)

var productGroupCheckEntityExists* = Call_ProductGroupCheckEntityExists_574377(
    name: "productGroupCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupCheckEntityExists_574378, base: "",
    url: url_ProductGroupCheckEntityExists_574379, schemes: {Scheme.Https})
type
  Call_ProductGroupDelete_574364 = ref object of OpenApiRestCall_573657
proc url_ProductGroupDelete_574366(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupDelete_574365(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the association between the specified group and product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574367 = path.getOrDefault("groupId")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "groupId", valid_574367
  var valid_574368 = path.getOrDefault("resourceGroupName")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "resourceGroupName", valid_574368
  var valid_574369 = path.getOrDefault("subscriptionId")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "subscriptionId", valid_574369
  var valid_574370 = path.getOrDefault("productId")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "productId", valid_574370
  var valid_574371 = path.getOrDefault("serviceName")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "serviceName", valid_574371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574372 = query.getOrDefault("api-version")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "api-version", valid_574372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574373: Call_ProductGroupDelete_574364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the association between the specified group and product.
  ## 
  let valid = call_574373.validator(path, query, header, formData, body)
  let scheme = call_574373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574373.url(scheme.get, call_574373.host, call_574373.base,
                         call_574373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574373, url, valid)

proc call*(call_574374: Call_ProductGroupDelete_574364; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productGroupDelete
  ## Deletes the association between the specified group and product.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574375 = newJObject()
  var query_574376 = newJObject()
  add(path_574375, "groupId", newJString(groupId))
  add(path_574375, "resourceGroupName", newJString(resourceGroupName))
  add(query_574376, "api-version", newJString(apiVersion))
  add(path_574375, "subscriptionId", newJString(subscriptionId))
  add(path_574375, "productId", newJString(productId))
  add(path_574375, "serviceName", newJString(serviceName))
  result = call_574374.call(path_574375, query_574376, nil, nil, nil)

var productGroupDelete* = Call_ProductGroupDelete_574364(
    name: "productGroupDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupDelete_574365, base: "",
    url: url_ProductGroupDelete_574366, schemes: {Scheme.Https})
type
  Call_ProductPolicyListByProduct_574390 = ref object of OpenApiRestCall_573657
proc url_ProductPolicyListByProduct_574392(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyListByProduct_574391(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the Product level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574393 = path.getOrDefault("resourceGroupName")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "resourceGroupName", valid_574393
  var valid_574394 = path.getOrDefault("subscriptionId")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "subscriptionId", valid_574394
  var valid_574395 = path.getOrDefault("productId")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "productId", valid_574395
  var valid_574396 = path.getOrDefault("serviceName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "serviceName", valid_574396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574397 = query.getOrDefault("api-version")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "api-version", valid_574397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574398: Call_ProductPolicyListByProduct_574390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_574398.validator(path, query, header, formData, body)
  let scheme = call_574398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574398.url(scheme.get, call_574398.host, call_574398.base,
                         call_574398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574398, url, valid)

proc call*(call_574399: Call_ProductPolicyListByProduct_574390;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productPolicyListByProduct
  ## Get the policy configuration at the Product level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574400 = newJObject()
  var query_574401 = newJObject()
  add(path_574400, "resourceGroupName", newJString(resourceGroupName))
  add(query_574401, "api-version", newJString(apiVersion))
  add(path_574400, "subscriptionId", newJString(subscriptionId))
  add(path_574400, "productId", newJString(productId))
  add(path_574400, "serviceName", newJString(serviceName))
  result = call_574399.call(path_574400, query_574401, nil, nil, nil)

var productPolicyListByProduct* = Call_ProductPolicyListByProduct_574390(
    name: "productPolicyListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies",
    validator: validate_ProductPolicyListByProduct_574391, base: "",
    url: url_ProductPolicyListByProduct_574392, schemes: {Scheme.Https})
type
  Call_ProductPolicyCreateOrUpdate_574428 = ref object of OpenApiRestCall_573657
proc url_ProductPolicyCreateOrUpdate_574430(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyCreateOrUpdate_574429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574431 = path.getOrDefault("resourceGroupName")
  valid_574431 = validateParameter(valid_574431, JString, required = true,
                                 default = nil)
  if valid_574431 != nil:
    section.add "resourceGroupName", valid_574431
  var valid_574432 = path.getOrDefault("subscriptionId")
  valid_574432 = validateParameter(valid_574432, JString, required = true,
                                 default = nil)
  if valid_574432 != nil:
    section.add "subscriptionId", valid_574432
  var valid_574433 = path.getOrDefault("policyId")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = newJString("policy"))
  if valid_574433 != nil:
    section.add "policyId", valid_574433
  var valid_574434 = path.getOrDefault("productId")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "productId", valid_574434
  var valid_574435 = path.getOrDefault("serviceName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "serviceName", valid_574435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574436 = query.getOrDefault("api-version")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "api-version", valid_574436
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

proc call*(call_574438: Call_ProductPolicyCreateOrUpdate_574428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the Product.
  ## 
  let valid = call_574438.validator(path, query, header, formData, body)
  let scheme = call_574438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574438.url(scheme.get, call_574438.host, call_574438.base,
                         call_574438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574438, url, valid)

proc call*(call_574439: Call_ProductPolicyCreateOrUpdate_574428;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; productId: string; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## productPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the Product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574440 = newJObject()
  var query_574441 = newJObject()
  var body_574442 = newJObject()
  add(path_574440, "resourceGroupName", newJString(resourceGroupName))
  add(query_574441, "api-version", newJString(apiVersion))
  add(path_574440, "subscriptionId", newJString(subscriptionId))
  add(path_574440, "policyId", newJString(policyId))
  if parameters != nil:
    body_574442 = parameters
  add(path_574440, "productId", newJString(productId))
  add(path_574440, "serviceName", newJString(serviceName))
  result = call_574439.call(path_574440, query_574441, nil, nil, body_574442)

var productPolicyCreateOrUpdate* = Call_ProductPolicyCreateOrUpdate_574428(
    name: "productPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyCreateOrUpdate_574429, base: "",
    url: url_ProductPolicyCreateOrUpdate_574430, schemes: {Scheme.Https})
type
  Call_ProductPolicyGet_574402 = ref object of OpenApiRestCall_573657
proc url_ProductPolicyGet_574404(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyGet_574403(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the policy configuration at the Product level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574405 = path.getOrDefault("resourceGroupName")
  valid_574405 = validateParameter(valid_574405, JString, required = true,
                                 default = nil)
  if valid_574405 != nil:
    section.add "resourceGroupName", valid_574405
  var valid_574406 = path.getOrDefault("subscriptionId")
  valid_574406 = validateParameter(valid_574406, JString, required = true,
                                 default = nil)
  if valid_574406 != nil:
    section.add "subscriptionId", valid_574406
  var valid_574420 = path.getOrDefault("policyId")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = newJString("policy"))
  if valid_574420 != nil:
    section.add "policyId", valid_574420
  var valid_574421 = path.getOrDefault("productId")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "productId", valid_574421
  var valid_574422 = path.getOrDefault("serviceName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "serviceName", valid_574422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574423 = query.getOrDefault("api-version")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "api-version", valid_574423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574424: Call_ProductPolicyGet_574402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_574424.validator(path, query, header, formData, body)
  let scheme = call_574424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574424.url(scheme.get, call_574424.host, call_574424.base,
                         call_574424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574424, url, valid)

proc call*(call_574425: Call_ProductPolicyGet_574402; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string; policyId: string = "policy"): Recallable =
  ## productPolicyGet
  ## Get the policy configuration at the Product level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574426 = newJObject()
  var query_574427 = newJObject()
  add(path_574426, "resourceGroupName", newJString(resourceGroupName))
  add(query_574427, "api-version", newJString(apiVersion))
  add(path_574426, "subscriptionId", newJString(subscriptionId))
  add(path_574426, "policyId", newJString(policyId))
  add(path_574426, "productId", newJString(productId))
  add(path_574426, "serviceName", newJString(serviceName))
  result = call_574425.call(path_574426, query_574427, nil, nil, nil)

var productPolicyGet* = Call_ProductPolicyGet_574402(name: "productPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyGet_574403, base: "",
    url: url_ProductPolicyGet_574404, schemes: {Scheme.Https})
type
  Call_ProductPolicyDelete_574443 = ref object of OpenApiRestCall_573657
proc url_ProductPolicyDelete_574445(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductPolicyDelete_574444(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574446 = path.getOrDefault("resourceGroupName")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "resourceGroupName", valid_574446
  var valid_574447 = path.getOrDefault("subscriptionId")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "subscriptionId", valid_574447
  var valid_574448 = path.getOrDefault("policyId")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = newJString("policy"))
  if valid_574448 != nil:
    section.add "policyId", valid_574448
  var valid_574449 = path.getOrDefault("productId")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "productId", valid_574449
  var valid_574450 = path.getOrDefault("serviceName")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "serviceName", valid_574450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574451 = query.getOrDefault("api-version")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = nil)
  if valid_574451 != nil:
    section.add "api-version", valid_574451
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the product policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574452 = header.getOrDefault("If-Match")
  valid_574452 = validateParameter(valid_574452, JString, required = true,
                                 default = nil)
  if valid_574452 != nil:
    section.add "If-Match", valid_574452
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574453: Call_ProductPolicyDelete_574443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Product.
  ## 
  let valid = call_574453.validator(path, query, header, formData, body)
  let scheme = call_574453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574453.url(scheme.get, call_574453.host, call_574453.base,
                         call_574453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574453, url, valid)

proc call*(call_574454: Call_ProductPolicyDelete_574443; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string; policyId: string = "policy"): Recallable =
  ## productPolicyDelete
  ## Deletes the policy configuration at the Product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574455 = newJObject()
  var query_574456 = newJObject()
  add(path_574455, "resourceGroupName", newJString(resourceGroupName))
  add(query_574456, "api-version", newJString(apiVersion))
  add(path_574455, "subscriptionId", newJString(subscriptionId))
  add(path_574455, "policyId", newJString(policyId))
  add(path_574455, "productId", newJString(productId))
  add(path_574455, "serviceName", newJString(serviceName))
  result = call_574454.call(path_574455, query_574456, nil, nil, nil)

var productPolicyDelete* = Call_ProductPolicyDelete_574443(
    name: "productPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyDelete_574444, base: "",
    url: url_ProductPolicyDelete_574445, schemes: {Scheme.Https})
type
  Call_ProductSubscriptionsList_574457 = ref object of OpenApiRestCall_573657
proc url_ProductSubscriptionsList_574459(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductSubscriptionsList_574458(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574460 = path.getOrDefault("resourceGroupName")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "resourceGroupName", valid_574460
  var valid_574461 = path.getOrDefault("subscriptionId")
  valid_574461 = validateParameter(valid_574461, JString, required = true,
                                 default = nil)
  if valid_574461 != nil:
    section.add "subscriptionId", valid_574461
  var valid_574462 = path.getOrDefault("productId")
  valid_574462 = validateParameter(valid_574462, JString, required = true,
                                 default = nil)
  if valid_574462 != nil:
    section.add "productId", valid_574462
  var valid_574463 = path.getOrDefault("serviceName")
  valid_574463 = validateParameter(valid_574463, JString, required = true,
                                 default = nil)
  if valid_574463 != nil:
    section.add "serviceName", valid_574463
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
  var valid_574464 = query.getOrDefault("api-version")
  valid_574464 = validateParameter(valid_574464, JString, required = true,
                                 default = nil)
  if valid_574464 != nil:
    section.add "api-version", valid_574464
  var valid_574465 = query.getOrDefault("$top")
  valid_574465 = validateParameter(valid_574465, JInt, required = false, default = nil)
  if valid_574465 != nil:
    section.add "$top", valid_574465
  var valid_574466 = query.getOrDefault("$skip")
  valid_574466 = validateParameter(valid_574466, JInt, required = false, default = nil)
  if valid_574466 != nil:
    section.add "$skip", valid_574466
  var valid_574467 = query.getOrDefault("$filter")
  valid_574467 = validateParameter(valid_574467, JString, required = false,
                                 default = nil)
  if valid_574467 != nil:
    section.add "$filter", valid_574467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574468: Call_ProductSubscriptionsList_574457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  let valid = call_574468.validator(path, query, header, formData, body)
  let scheme = call_574468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574468.url(scheme.get, call_574468.host, call_574468.base,
                         call_574468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574468, url, valid)

proc call*(call_574469: Call_ProductSubscriptionsList_574457;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## productSubscriptionsList
  ## Lists the collection of subscriptions to the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  var path_574470 = newJObject()
  var query_574471 = newJObject()
  add(path_574470, "resourceGroupName", newJString(resourceGroupName))
  add(query_574471, "api-version", newJString(apiVersion))
  add(path_574470, "subscriptionId", newJString(subscriptionId))
  add(query_574471, "$top", newJInt(Top))
  add(query_574471, "$skip", newJInt(Skip))
  add(path_574470, "productId", newJString(productId))
  add(path_574470, "serviceName", newJString(serviceName))
  add(query_574471, "$filter", newJString(Filter))
  result = call_574469.call(path_574470, query_574471, nil, nil, nil)

var productSubscriptionsList* = Call_ProductSubscriptionsList_574457(
    name: "productSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/subscriptions",
    validator: validate_ProductSubscriptionsList_574458, base: "",
    url: url_ProductSubscriptionsList_574459, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
