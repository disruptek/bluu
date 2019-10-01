
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  Call_ProductListByService_596679 = ref object of OpenApiRestCall_596457
proc url_ProductListByService_596681(protocol: Scheme; host: string; base: string;
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

proc validate_ProductListByService_596680(path: JsonNode; query: JsonNode;
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
  var valid_596842 = path.getOrDefault("resourceGroupName")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "resourceGroupName", valid_596842
  var valid_596843 = path.getOrDefault("subscriptionId")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "subscriptionId", valid_596843
  var valid_596844 = path.getOrDefault("serviceName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "serviceName", valid_596844
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
  var valid_596845 = query.getOrDefault("api-version")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "api-version", valid_596845
  var valid_596846 = query.getOrDefault("$top")
  valid_596846 = validateParameter(valid_596846, JInt, required = false, default = nil)
  if valid_596846 != nil:
    section.add "$top", valid_596846
  var valid_596847 = query.getOrDefault("$skip")
  valid_596847 = validateParameter(valid_596847, JInt, required = false, default = nil)
  if valid_596847 != nil:
    section.add "$skip", valid_596847
  var valid_596848 = query.getOrDefault("expandGroups")
  valid_596848 = validateParameter(valid_596848, JBool, required = false, default = nil)
  if valid_596848 != nil:
    section.add "expandGroups", valid_596848
  var valid_596849 = query.getOrDefault("$filter")
  valid_596849 = validateParameter(valid_596849, JString, required = false,
                                 default = nil)
  if valid_596849 != nil:
    section.add "$filter", valid_596849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596876: Call_ProductListByService_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of products in the specified service instance.
  ## 
  let valid = call_596876.validator(path, query, header, formData, body)
  let scheme = call_596876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596876.url(scheme.get, call_596876.host, call_596876.base,
                         call_596876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596876, url, valid)

proc call*(call_596947: Call_ProductListByService_596679;
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
  var path_596948 = newJObject()
  var query_596950 = newJObject()
  add(path_596948, "resourceGroupName", newJString(resourceGroupName))
  add(query_596950, "api-version", newJString(apiVersion))
  add(path_596948, "subscriptionId", newJString(subscriptionId))
  add(query_596950, "$top", newJInt(Top))
  add(query_596950, "$skip", newJInt(Skip))
  add(query_596950, "expandGroups", newJBool(expandGroups))
  add(path_596948, "serviceName", newJString(serviceName))
  add(query_596950, "$filter", newJString(Filter))
  result = call_596947.call(path_596948, query_596950, nil, nil, nil)

var productListByService* = Call_ProductListByService_596679(
    name: "productListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products",
    validator: validate_ProductListByService_596680, base: "",
    url: url_ProductListByService_596681, schemes: {Scheme.Https})
type
  Call_ProductCreateOrUpdate_597010 = ref object of OpenApiRestCall_596457
proc url_ProductCreateOrUpdate_597012(protocol: Scheme; host: string; base: string;
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

proc validate_ProductCreateOrUpdate_597011(path: JsonNode; query: JsonNode;
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
  var valid_597030 = path.getOrDefault("resourceGroupName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "resourceGroupName", valid_597030
  var valid_597031 = path.getOrDefault("subscriptionId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "subscriptionId", valid_597031
  var valid_597032 = path.getOrDefault("productId")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "productId", valid_597032
  var valid_597033 = path.getOrDefault("serviceName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "serviceName", valid_597033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597034 = query.getOrDefault("api-version")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "api-version", valid_597034
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597035 = header.getOrDefault("If-Match")
  valid_597035 = validateParameter(valid_597035, JString, required = false,
                                 default = nil)
  if valid_597035 != nil:
    section.add "If-Match", valid_597035
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

proc call*(call_597037: Call_ProductCreateOrUpdate_597010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a product.
  ## 
  let valid = call_597037.validator(path, query, header, formData, body)
  let scheme = call_597037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597037.url(scheme.get, call_597037.host, call_597037.base,
                         call_597037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597037, url, valid)

proc call*(call_597038: Call_ProductCreateOrUpdate_597010;
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
  var path_597039 = newJObject()
  var query_597040 = newJObject()
  var body_597041 = newJObject()
  add(path_597039, "resourceGroupName", newJString(resourceGroupName))
  add(query_597040, "api-version", newJString(apiVersion))
  add(path_597039, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597041 = parameters
  add(path_597039, "productId", newJString(productId))
  add(path_597039, "serviceName", newJString(serviceName))
  result = call_597038.call(path_597039, query_597040, nil, nil, body_597041)

var productCreateOrUpdate* = Call_ProductCreateOrUpdate_597010(
    name: "productCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductCreateOrUpdate_597011, base: "",
    url: url_ProductCreateOrUpdate_597012, schemes: {Scheme.Https})
type
  Call_ProductGetEntityTag_597056 = ref object of OpenApiRestCall_596457
proc url_ProductGetEntityTag_597058(protocol: Scheme; host: string; base: string;
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

proc validate_ProductGetEntityTag_597057(path: JsonNode; query: JsonNode;
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
  var valid_597059 = path.getOrDefault("resourceGroupName")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "resourceGroupName", valid_597059
  var valid_597060 = path.getOrDefault("subscriptionId")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "subscriptionId", valid_597060
  var valid_597061 = path.getOrDefault("productId")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "productId", valid_597061
  var valid_597062 = path.getOrDefault("serviceName")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "serviceName", valid_597062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597063 = query.getOrDefault("api-version")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "api-version", valid_597063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597064: Call_ProductGetEntityTag_597056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the product specified by its identifier.
  ## 
  let valid = call_597064.validator(path, query, header, formData, body)
  let scheme = call_597064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597064.url(scheme.get, call_597064.host, call_597064.base,
                         call_597064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597064, url, valid)

proc call*(call_597065: Call_ProductGetEntityTag_597056; resourceGroupName: string;
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
  var path_597066 = newJObject()
  var query_597067 = newJObject()
  add(path_597066, "resourceGroupName", newJString(resourceGroupName))
  add(query_597067, "api-version", newJString(apiVersion))
  add(path_597066, "subscriptionId", newJString(subscriptionId))
  add(path_597066, "productId", newJString(productId))
  add(path_597066, "serviceName", newJString(serviceName))
  result = call_597065.call(path_597066, query_597067, nil, nil, nil)

var productGetEntityTag* = Call_ProductGetEntityTag_597056(
    name: "productGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductGetEntityTag_597057, base: "",
    url: url_ProductGetEntityTag_597058, schemes: {Scheme.Https})
type
  Call_ProductGet_596989 = ref object of OpenApiRestCall_596457
proc url_ProductGet_596991(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ProductGet_596990(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597001 = path.getOrDefault("resourceGroupName")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "resourceGroupName", valid_597001
  var valid_597002 = path.getOrDefault("subscriptionId")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "subscriptionId", valid_597002
  var valid_597003 = path.getOrDefault("productId")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = nil)
  if valid_597003 != nil:
    section.add "productId", valid_597003
  var valid_597004 = path.getOrDefault("serviceName")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "serviceName", valid_597004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597005 = query.getOrDefault("api-version")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "api-version", valid_597005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597006: Call_ProductGet_596989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the product specified by its identifier.
  ## 
  let valid = call_597006.validator(path, query, header, formData, body)
  let scheme = call_597006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597006.url(scheme.get, call_597006.host, call_597006.base,
                         call_597006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597006, url, valid)

proc call*(call_597007: Call_ProductGet_596989; resourceGroupName: string;
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
  var path_597008 = newJObject()
  var query_597009 = newJObject()
  add(path_597008, "resourceGroupName", newJString(resourceGroupName))
  add(query_597009, "api-version", newJString(apiVersion))
  add(path_597008, "subscriptionId", newJString(subscriptionId))
  add(path_597008, "productId", newJString(productId))
  add(path_597008, "serviceName", newJString(serviceName))
  result = call_597007.call(path_597008, query_597009, nil, nil, nil)

var productGet* = Call_ProductGet_596989(name: "productGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
                                      validator: validate_ProductGet_596990,
                                      base: "", url: url_ProductGet_596991,
                                      schemes: {Scheme.Https})
type
  Call_ProductUpdate_597068 = ref object of OpenApiRestCall_596457
proc url_ProductUpdate_597070(protocol: Scheme; host: string; base: string;
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

proc validate_ProductUpdate_597069(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597071 = path.getOrDefault("resourceGroupName")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "resourceGroupName", valid_597071
  var valid_597072 = path.getOrDefault("subscriptionId")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "subscriptionId", valid_597072
  var valid_597073 = path.getOrDefault("productId")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "productId", valid_597073
  var valid_597074 = path.getOrDefault("serviceName")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "serviceName", valid_597074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597075 = query.getOrDefault("api-version")
  valid_597075 = validateParameter(valid_597075, JString, required = true,
                                 default = nil)
  if valid_597075 != nil:
    section.add "api-version", valid_597075
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597076 = header.getOrDefault("If-Match")
  valid_597076 = validateParameter(valid_597076, JString, required = true,
                                 default = nil)
  if valid_597076 != nil:
    section.add "If-Match", valid_597076
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

proc call*(call_597078: Call_ProductUpdate_597068; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update product.
  ## 
  let valid = call_597078.validator(path, query, header, formData, body)
  let scheme = call_597078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597078.url(scheme.get, call_597078.host, call_597078.base,
                         call_597078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597078, url, valid)

proc call*(call_597079: Call_ProductUpdate_597068; resourceGroupName: string;
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
  var path_597080 = newJObject()
  var query_597081 = newJObject()
  var body_597082 = newJObject()
  add(path_597080, "resourceGroupName", newJString(resourceGroupName))
  add(query_597081, "api-version", newJString(apiVersion))
  add(path_597080, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597082 = parameters
  add(path_597080, "productId", newJString(productId))
  add(path_597080, "serviceName", newJString(serviceName))
  result = call_597079.call(path_597080, query_597081, nil, nil, body_597082)

var productUpdate* = Call_ProductUpdate_597068(name: "productUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductUpdate_597069, base: "", url: url_ProductUpdate_597070,
    schemes: {Scheme.Https})
type
  Call_ProductDelete_597042 = ref object of OpenApiRestCall_596457
proc url_ProductDelete_597044(protocol: Scheme; host: string; base: string;
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

proc validate_ProductDelete_597043(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597045 = path.getOrDefault("resourceGroupName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "resourceGroupName", valid_597045
  var valid_597046 = path.getOrDefault("subscriptionId")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "subscriptionId", valid_597046
  var valid_597047 = path.getOrDefault("productId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "productId", valid_597047
  var valid_597048 = path.getOrDefault("serviceName")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "serviceName", valid_597048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Delete existing subscriptions associated with the product or not.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597049 = query.getOrDefault("api-version")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "api-version", valid_597049
  var valid_597050 = query.getOrDefault("deleteSubscriptions")
  valid_597050 = validateParameter(valid_597050, JBool, required = false, default = nil)
  if valid_597050 != nil:
    section.add "deleteSubscriptions", valid_597050
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597051 = header.getOrDefault("If-Match")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "If-Match", valid_597051
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597052: Call_ProductDelete_597042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete product.
  ## 
  let valid = call_597052.validator(path, query, header, formData, body)
  let scheme = call_597052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597052.url(scheme.get, call_597052.host, call_597052.base,
                         call_597052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597052, url, valid)

proc call*(call_597053: Call_ProductDelete_597042; resourceGroupName: string;
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
  ##                      : Delete existing subscriptions associated with the product or not.
  var path_597054 = newJObject()
  var query_597055 = newJObject()
  add(path_597054, "resourceGroupName", newJString(resourceGroupName))
  add(query_597055, "api-version", newJString(apiVersion))
  add(path_597054, "subscriptionId", newJString(subscriptionId))
  add(path_597054, "productId", newJString(productId))
  add(path_597054, "serviceName", newJString(serviceName))
  add(query_597055, "deleteSubscriptions", newJBool(deleteSubscriptions))
  result = call_597053.call(path_597054, query_597055, nil, nil, nil)

var productDelete* = Call_ProductDelete_597042(name: "productDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductDelete_597043, base: "", url: url_ProductDelete_597044,
    schemes: {Scheme.Https})
type
  Call_ProductApiListByProduct_597083 = ref object of OpenApiRestCall_596457
proc url_ProductApiListByProduct_597085(protocol: Scheme; host: string; base: string;
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

proc validate_ProductApiListByProduct_597084(path: JsonNode; query: JsonNode;
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
  var valid_597086 = path.getOrDefault("resourceGroupName")
  valid_597086 = validateParameter(valid_597086, JString, required = true,
                                 default = nil)
  if valid_597086 != nil:
    section.add "resourceGroupName", valid_597086
  var valid_597087 = path.getOrDefault("subscriptionId")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = nil)
  if valid_597087 != nil:
    section.add "subscriptionId", valid_597087
  var valid_597088 = path.getOrDefault("productId")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "productId", valid_597088
  var valid_597089 = path.getOrDefault("serviceName")
  valid_597089 = validateParameter(valid_597089, JString, required = true,
                                 default = nil)
  if valid_597089 != nil:
    section.add "serviceName", valid_597089
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
  var valid_597090 = query.getOrDefault("api-version")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "api-version", valid_597090
  var valid_597091 = query.getOrDefault("$top")
  valid_597091 = validateParameter(valid_597091, JInt, required = false, default = nil)
  if valid_597091 != nil:
    section.add "$top", valid_597091
  var valid_597092 = query.getOrDefault("$skip")
  valid_597092 = validateParameter(valid_597092, JInt, required = false, default = nil)
  if valid_597092 != nil:
    section.add "$skip", valid_597092
  var valid_597093 = query.getOrDefault("$filter")
  valid_597093 = validateParameter(valid_597093, JString, required = false,
                                 default = nil)
  if valid_597093 != nil:
    section.add "$filter", valid_597093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597094: Call_ProductApiListByProduct_597083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the APIs associated with a product.
  ## 
  let valid = call_597094.validator(path, query, header, formData, body)
  let scheme = call_597094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597094.url(scheme.get, call_597094.host, call_597094.base,
                         call_597094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597094, url, valid)

proc call*(call_597095: Call_ProductApiListByProduct_597083;
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
  var path_597096 = newJObject()
  var query_597097 = newJObject()
  add(path_597096, "resourceGroupName", newJString(resourceGroupName))
  add(query_597097, "api-version", newJString(apiVersion))
  add(path_597096, "subscriptionId", newJString(subscriptionId))
  add(query_597097, "$top", newJInt(Top))
  add(query_597097, "$skip", newJInt(Skip))
  add(path_597096, "productId", newJString(productId))
  add(path_597096, "serviceName", newJString(serviceName))
  add(query_597097, "$filter", newJString(Filter))
  result = call_597095.call(path_597096, query_597097, nil, nil, nil)

var productApiListByProduct* = Call_ProductApiListByProduct_597083(
    name: "productApiListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis",
    validator: validate_ProductApiListByProduct_597084, base: "",
    url: url_ProductApiListByProduct_597085, schemes: {Scheme.Https})
type
  Call_ProductApiCreateOrUpdate_597098 = ref object of OpenApiRestCall_596457
proc url_ProductApiCreateOrUpdate_597100(protocol: Scheme; host: string;
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

proc validate_ProductApiCreateOrUpdate_597099(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds an API to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597101 = path.getOrDefault("resourceGroupName")
  valid_597101 = validateParameter(valid_597101, JString, required = true,
                                 default = nil)
  if valid_597101 != nil:
    section.add "resourceGroupName", valid_597101
  var valid_597102 = path.getOrDefault("apiId")
  valid_597102 = validateParameter(valid_597102, JString, required = true,
                                 default = nil)
  if valid_597102 != nil:
    section.add "apiId", valid_597102
  var valid_597103 = path.getOrDefault("subscriptionId")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "subscriptionId", valid_597103
  var valid_597104 = path.getOrDefault("productId")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = nil)
  if valid_597104 != nil:
    section.add "productId", valid_597104
  var valid_597105 = path.getOrDefault("serviceName")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "serviceName", valid_597105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597106 = query.getOrDefault("api-version")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "api-version", valid_597106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597107: Call_ProductApiCreateOrUpdate_597098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an API to the specified product.
  ## 
  let valid = call_597107.validator(path, query, header, formData, body)
  let scheme = call_597107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597107.url(scheme.get, call_597107.host, call_597107.base,
                         call_597107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597107, url, valid)

proc call*(call_597108: Call_ProductApiCreateOrUpdate_597098;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; productId: string; serviceName: string): Recallable =
  ## productApiCreateOrUpdate
  ## Adds an API to the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597109 = newJObject()
  var query_597110 = newJObject()
  add(path_597109, "resourceGroupName", newJString(resourceGroupName))
  add(query_597110, "api-version", newJString(apiVersion))
  add(path_597109, "apiId", newJString(apiId))
  add(path_597109, "subscriptionId", newJString(subscriptionId))
  add(path_597109, "productId", newJString(productId))
  add(path_597109, "serviceName", newJString(serviceName))
  result = call_597108.call(path_597109, query_597110, nil, nil, nil)

var productApiCreateOrUpdate* = Call_ProductApiCreateOrUpdate_597098(
    name: "productApiCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiCreateOrUpdate_597099, base: "",
    url: url_ProductApiCreateOrUpdate_597100, schemes: {Scheme.Https})
type
  Call_ProductApiCheckEntityExists_597124 = ref object of OpenApiRestCall_596457
proc url_ProductApiCheckEntityExists_597126(protocol: Scheme; host: string;
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

proc validate_ProductApiCheckEntityExists_597125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that API entity specified by identifier is associated with the Product entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597127 = path.getOrDefault("resourceGroupName")
  valid_597127 = validateParameter(valid_597127, JString, required = true,
                                 default = nil)
  if valid_597127 != nil:
    section.add "resourceGroupName", valid_597127
  var valid_597128 = path.getOrDefault("apiId")
  valid_597128 = validateParameter(valid_597128, JString, required = true,
                                 default = nil)
  if valid_597128 != nil:
    section.add "apiId", valid_597128
  var valid_597129 = path.getOrDefault("subscriptionId")
  valid_597129 = validateParameter(valid_597129, JString, required = true,
                                 default = nil)
  if valid_597129 != nil:
    section.add "subscriptionId", valid_597129
  var valid_597130 = path.getOrDefault("productId")
  valid_597130 = validateParameter(valid_597130, JString, required = true,
                                 default = nil)
  if valid_597130 != nil:
    section.add "productId", valid_597130
  var valid_597131 = path.getOrDefault("serviceName")
  valid_597131 = validateParameter(valid_597131, JString, required = true,
                                 default = nil)
  if valid_597131 != nil:
    section.add "serviceName", valid_597131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597132 = query.getOrDefault("api-version")
  valid_597132 = validateParameter(valid_597132, JString, required = true,
                                 default = nil)
  if valid_597132 != nil:
    section.add "api-version", valid_597132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597133: Call_ProductApiCheckEntityExists_597124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that API entity specified by identifier is associated with the Product entity.
  ## 
  let valid = call_597133.validator(path, query, header, formData, body)
  let scheme = call_597133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597133.url(scheme.get, call_597133.host, call_597133.base,
                         call_597133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597133, url, valid)

proc call*(call_597134: Call_ProductApiCheckEntityExists_597124;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; productId: string; serviceName: string): Recallable =
  ## productApiCheckEntityExists
  ## Checks that API entity specified by identifier is associated with the Product entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597135 = newJObject()
  var query_597136 = newJObject()
  add(path_597135, "resourceGroupName", newJString(resourceGroupName))
  add(query_597136, "api-version", newJString(apiVersion))
  add(path_597135, "apiId", newJString(apiId))
  add(path_597135, "subscriptionId", newJString(subscriptionId))
  add(path_597135, "productId", newJString(productId))
  add(path_597135, "serviceName", newJString(serviceName))
  result = call_597134.call(path_597135, query_597136, nil, nil, nil)

var productApiCheckEntityExists* = Call_ProductApiCheckEntityExists_597124(
    name: "productApiCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiCheckEntityExists_597125, base: "",
    url: url_ProductApiCheckEntityExists_597126, schemes: {Scheme.Https})
type
  Call_ProductApiDelete_597111 = ref object of OpenApiRestCall_596457
proc url_ProductApiDelete_597113(protocol: Scheme; host: string; base: string;
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

proc validate_ProductApiDelete_597112(path: JsonNode; query: JsonNode;
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
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597114 = path.getOrDefault("resourceGroupName")
  valid_597114 = validateParameter(valid_597114, JString, required = true,
                                 default = nil)
  if valid_597114 != nil:
    section.add "resourceGroupName", valid_597114
  var valid_597115 = path.getOrDefault("apiId")
  valid_597115 = validateParameter(valid_597115, JString, required = true,
                                 default = nil)
  if valid_597115 != nil:
    section.add "apiId", valid_597115
  var valid_597116 = path.getOrDefault("subscriptionId")
  valid_597116 = validateParameter(valid_597116, JString, required = true,
                                 default = nil)
  if valid_597116 != nil:
    section.add "subscriptionId", valid_597116
  var valid_597117 = path.getOrDefault("productId")
  valid_597117 = validateParameter(valid_597117, JString, required = true,
                                 default = nil)
  if valid_597117 != nil:
    section.add "productId", valid_597117
  var valid_597118 = path.getOrDefault("serviceName")
  valid_597118 = validateParameter(valid_597118, JString, required = true,
                                 default = nil)
  if valid_597118 != nil:
    section.add "serviceName", valid_597118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597119 = query.getOrDefault("api-version")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "api-version", valid_597119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597120: Call_ProductApiDelete_597111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API from the specified product.
  ## 
  let valid = call_597120.validator(path, query, header, formData, body)
  let scheme = call_597120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597120.url(scheme.get, call_597120.host, call_597120.base,
                         call_597120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597120, url, valid)

proc call*(call_597121: Call_ProductApiDelete_597111; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productApiDelete
  ## Deletes the specified API from the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597122 = newJObject()
  var query_597123 = newJObject()
  add(path_597122, "resourceGroupName", newJString(resourceGroupName))
  add(query_597123, "api-version", newJString(apiVersion))
  add(path_597122, "apiId", newJString(apiId))
  add(path_597122, "subscriptionId", newJString(subscriptionId))
  add(path_597122, "productId", newJString(productId))
  add(path_597122, "serviceName", newJString(serviceName))
  result = call_597121.call(path_597122, query_597123, nil, nil, nil)

var productApiDelete* = Call_ProductApiDelete_597111(name: "productApiDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiDelete_597112, base: "",
    url: url_ProductApiDelete_597113, schemes: {Scheme.Https})
type
  Call_ProductGroupListByProduct_597137 = ref object of OpenApiRestCall_596457
proc url_ProductGroupListByProduct_597139(protocol: Scheme; host: string;
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

proc validate_ProductGroupListByProduct_597138(path: JsonNode; query: JsonNode;
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
  var valid_597140 = path.getOrDefault("resourceGroupName")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "resourceGroupName", valid_597140
  var valid_597141 = path.getOrDefault("subscriptionId")
  valid_597141 = validateParameter(valid_597141, JString, required = true,
                                 default = nil)
  if valid_597141 != nil:
    section.add "subscriptionId", valid_597141
  var valid_597142 = path.getOrDefault("productId")
  valid_597142 = validateParameter(valid_597142, JString, required = true,
                                 default = nil)
  if valid_597142 != nil:
    section.add "productId", valid_597142
  var valid_597143 = path.getOrDefault("serviceName")
  valid_597143 = validateParameter(valid_597143, JString, required = true,
                                 default = nil)
  if valid_597143 != nil:
    section.add "serviceName", valid_597143
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
  var valid_597144 = query.getOrDefault("api-version")
  valid_597144 = validateParameter(valid_597144, JString, required = true,
                                 default = nil)
  if valid_597144 != nil:
    section.add "api-version", valid_597144
  var valid_597145 = query.getOrDefault("$top")
  valid_597145 = validateParameter(valid_597145, JInt, required = false, default = nil)
  if valid_597145 != nil:
    section.add "$top", valid_597145
  var valid_597146 = query.getOrDefault("$skip")
  valid_597146 = validateParameter(valid_597146, JInt, required = false, default = nil)
  if valid_597146 != nil:
    section.add "$skip", valid_597146
  var valid_597147 = query.getOrDefault("$filter")
  valid_597147 = validateParameter(valid_597147, JString, required = false,
                                 default = nil)
  if valid_597147 != nil:
    section.add "$filter", valid_597147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597148: Call_ProductGroupListByProduct_597137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  let valid = call_597148.validator(path, query, header, formData, body)
  let scheme = call_597148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597148.url(scheme.get, call_597148.host, call_597148.base,
                         call_597148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597148, url, valid)

proc call*(call_597149: Call_ProductGroupListByProduct_597137;
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
  var path_597150 = newJObject()
  var query_597151 = newJObject()
  add(path_597150, "resourceGroupName", newJString(resourceGroupName))
  add(query_597151, "api-version", newJString(apiVersion))
  add(path_597150, "subscriptionId", newJString(subscriptionId))
  add(query_597151, "$top", newJInt(Top))
  add(query_597151, "$skip", newJInt(Skip))
  add(path_597150, "productId", newJString(productId))
  add(path_597150, "serviceName", newJString(serviceName))
  add(query_597151, "$filter", newJString(Filter))
  result = call_597149.call(path_597150, query_597151, nil, nil, nil)

var productGroupListByProduct* = Call_ProductGroupListByProduct_597137(
    name: "productGroupListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups",
    validator: validate_ProductGroupListByProduct_597138, base: "",
    url: url_ProductGroupListByProduct_597139, schemes: {Scheme.Https})
type
  Call_ProductGroupCreateOrUpdate_597152 = ref object of OpenApiRestCall_596457
proc url_ProductGroupCreateOrUpdate_597154(protocol: Scheme; host: string;
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

proc validate_ProductGroupCreateOrUpdate_597153(path: JsonNode; query: JsonNode;
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
  var valid_597155 = path.getOrDefault("groupId")
  valid_597155 = validateParameter(valid_597155, JString, required = true,
                                 default = nil)
  if valid_597155 != nil:
    section.add "groupId", valid_597155
  var valid_597156 = path.getOrDefault("resourceGroupName")
  valid_597156 = validateParameter(valid_597156, JString, required = true,
                                 default = nil)
  if valid_597156 != nil:
    section.add "resourceGroupName", valid_597156
  var valid_597157 = path.getOrDefault("subscriptionId")
  valid_597157 = validateParameter(valid_597157, JString, required = true,
                                 default = nil)
  if valid_597157 != nil:
    section.add "subscriptionId", valid_597157
  var valid_597158 = path.getOrDefault("productId")
  valid_597158 = validateParameter(valid_597158, JString, required = true,
                                 default = nil)
  if valid_597158 != nil:
    section.add "productId", valid_597158
  var valid_597159 = path.getOrDefault("serviceName")
  valid_597159 = validateParameter(valid_597159, JString, required = true,
                                 default = nil)
  if valid_597159 != nil:
    section.add "serviceName", valid_597159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597160 = query.getOrDefault("api-version")
  valid_597160 = validateParameter(valid_597160, JString, required = true,
                                 default = nil)
  if valid_597160 != nil:
    section.add "api-version", valid_597160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597161: Call_ProductGroupCreateOrUpdate_597152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  let valid = call_597161.validator(path, query, header, formData, body)
  let scheme = call_597161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597161.url(scheme.get, call_597161.host, call_597161.base,
                         call_597161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597161, url, valid)

proc call*(call_597162: Call_ProductGroupCreateOrUpdate_597152; groupId: string;
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
  var path_597163 = newJObject()
  var query_597164 = newJObject()
  add(path_597163, "groupId", newJString(groupId))
  add(path_597163, "resourceGroupName", newJString(resourceGroupName))
  add(query_597164, "api-version", newJString(apiVersion))
  add(path_597163, "subscriptionId", newJString(subscriptionId))
  add(path_597163, "productId", newJString(productId))
  add(path_597163, "serviceName", newJString(serviceName))
  result = call_597162.call(path_597163, query_597164, nil, nil, nil)

var productGroupCreateOrUpdate* = Call_ProductGroupCreateOrUpdate_597152(
    name: "productGroupCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupCreateOrUpdate_597153, base: "",
    url: url_ProductGroupCreateOrUpdate_597154, schemes: {Scheme.Https})
type
  Call_ProductGroupCheckEntityExists_597178 = ref object of OpenApiRestCall_596457
proc url_ProductGroupCheckEntityExists_597180(protocol: Scheme; host: string;
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

proc validate_ProductGroupCheckEntityExists_597179(path: JsonNode; query: JsonNode;
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
  var valid_597181 = path.getOrDefault("groupId")
  valid_597181 = validateParameter(valid_597181, JString, required = true,
                                 default = nil)
  if valid_597181 != nil:
    section.add "groupId", valid_597181
  var valid_597182 = path.getOrDefault("resourceGroupName")
  valid_597182 = validateParameter(valid_597182, JString, required = true,
                                 default = nil)
  if valid_597182 != nil:
    section.add "resourceGroupName", valid_597182
  var valid_597183 = path.getOrDefault("subscriptionId")
  valid_597183 = validateParameter(valid_597183, JString, required = true,
                                 default = nil)
  if valid_597183 != nil:
    section.add "subscriptionId", valid_597183
  var valid_597184 = path.getOrDefault("productId")
  valid_597184 = validateParameter(valid_597184, JString, required = true,
                                 default = nil)
  if valid_597184 != nil:
    section.add "productId", valid_597184
  var valid_597185 = path.getOrDefault("serviceName")
  valid_597185 = validateParameter(valid_597185, JString, required = true,
                                 default = nil)
  if valid_597185 != nil:
    section.add "serviceName", valid_597185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597186 = query.getOrDefault("api-version")
  valid_597186 = validateParameter(valid_597186, JString, required = true,
                                 default = nil)
  if valid_597186 != nil:
    section.add "api-version", valid_597186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597187: Call_ProductGroupCheckEntityExists_597178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that Group entity specified by identifier is associated with the Product entity.
  ## 
  let valid = call_597187.validator(path, query, header, formData, body)
  let scheme = call_597187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597187.url(scheme.get, call_597187.host, call_597187.base,
                         call_597187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597187, url, valid)

proc call*(call_597188: Call_ProductGroupCheckEntityExists_597178; groupId: string;
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
  var path_597189 = newJObject()
  var query_597190 = newJObject()
  add(path_597189, "groupId", newJString(groupId))
  add(path_597189, "resourceGroupName", newJString(resourceGroupName))
  add(query_597190, "api-version", newJString(apiVersion))
  add(path_597189, "subscriptionId", newJString(subscriptionId))
  add(path_597189, "productId", newJString(productId))
  add(path_597189, "serviceName", newJString(serviceName))
  result = call_597188.call(path_597189, query_597190, nil, nil, nil)

var productGroupCheckEntityExists* = Call_ProductGroupCheckEntityExists_597178(
    name: "productGroupCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupCheckEntityExists_597179, base: "",
    url: url_ProductGroupCheckEntityExists_597180, schemes: {Scheme.Https})
type
  Call_ProductGroupDelete_597165 = ref object of OpenApiRestCall_596457
proc url_ProductGroupDelete_597167(protocol: Scheme; host: string; base: string;
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

proc validate_ProductGroupDelete_597166(path: JsonNode; query: JsonNode;
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
  var valid_597168 = path.getOrDefault("groupId")
  valid_597168 = validateParameter(valid_597168, JString, required = true,
                                 default = nil)
  if valid_597168 != nil:
    section.add "groupId", valid_597168
  var valid_597169 = path.getOrDefault("resourceGroupName")
  valid_597169 = validateParameter(valid_597169, JString, required = true,
                                 default = nil)
  if valid_597169 != nil:
    section.add "resourceGroupName", valid_597169
  var valid_597170 = path.getOrDefault("subscriptionId")
  valid_597170 = validateParameter(valid_597170, JString, required = true,
                                 default = nil)
  if valid_597170 != nil:
    section.add "subscriptionId", valid_597170
  var valid_597171 = path.getOrDefault("productId")
  valid_597171 = validateParameter(valid_597171, JString, required = true,
                                 default = nil)
  if valid_597171 != nil:
    section.add "productId", valid_597171
  var valid_597172 = path.getOrDefault("serviceName")
  valid_597172 = validateParameter(valid_597172, JString, required = true,
                                 default = nil)
  if valid_597172 != nil:
    section.add "serviceName", valid_597172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597173 = query.getOrDefault("api-version")
  valid_597173 = validateParameter(valid_597173, JString, required = true,
                                 default = nil)
  if valid_597173 != nil:
    section.add "api-version", valid_597173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597174: Call_ProductGroupDelete_597165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the association between the specified group and product.
  ## 
  let valid = call_597174.validator(path, query, header, formData, body)
  let scheme = call_597174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597174.url(scheme.get, call_597174.host, call_597174.base,
                         call_597174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597174, url, valid)

proc call*(call_597175: Call_ProductGroupDelete_597165; groupId: string;
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
  var path_597176 = newJObject()
  var query_597177 = newJObject()
  add(path_597176, "groupId", newJString(groupId))
  add(path_597176, "resourceGroupName", newJString(resourceGroupName))
  add(query_597177, "api-version", newJString(apiVersion))
  add(path_597176, "subscriptionId", newJString(subscriptionId))
  add(path_597176, "productId", newJString(productId))
  add(path_597176, "serviceName", newJString(serviceName))
  result = call_597175.call(path_597176, query_597177, nil, nil, nil)

var productGroupDelete* = Call_ProductGroupDelete_597165(
    name: "productGroupDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupDelete_597166, base: "",
    url: url_ProductGroupDelete_597167, schemes: {Scheme.Https})
type
  Call_ProductPolicyListByProduct_597191 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyListByProduct_597193(protocol: Scheme; host: string;
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

proc validate_ProductPolicyListByProduct_597192(path: JsonNode; query: JsonNode;
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
  var valid_597194 = path.getOrDefault("resourceGroupName")
  valid_597194 = validateParameter(valid_597194, JString, required = true,
                                 default = nil)
  if valid_597194 != nil:
    section.add "resourceGroupName", valid_597194
  var valid_597195 = path.getOrDefault("subscriptionId")
  valid_597195 = validateParameter(valid_597195, JString, required = true,
                                 default = nil)
  if valid_597195 != nil:
    section.add "subscriptionId", valid_597195
  var valid_597196 = path.getOrDefault("productId")
  valid_597196 = validateParameter(valid_597196, JString, required = true,
                                 default = nil)
  if valid_597196 != nil:
    section.add "productId", valid_597196
  var valid_597197 = path.getOrDefault("serviceName")
  valid_597197 = validateParameter(valid_597197, JString, required = true,
                                 default = nil)
  if valid_597197 != nil:
    section.add "serviceName", valid_597197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597198 = query.getOrDefault("api-version")
  valid_597198 = validateParameter(valid_597198, JString, required = true,
                                 default = nil)
  if valid_597198 != nil:
    section.add "api-version", valid_597198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597199: Call_ProductPolicyListByProduct_597191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_597199.validator(path, query, header, formData, body)
  let scheme = call_597199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597199.url(scheme.get, call_597199.host, call_597199.base,
                         call_597199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597199, url, valid)

proc call*(call_597200: Call_ProductPolicyListByProduct_597191;
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
  var path_597201 = newJObject()
  var query_597202 = newJObject()
  add(path_597201, "resourceGroupName", newJString(resourceGroupName))
  add(query_597202, "api-version", newJString(apiVersion))
  add(path_597201, "subscriptionId", newJString(subscriptionId))
  add(path_597201, "productId", newJString(productId))
  add(path_597201, "serviceName", newJString(serviceName))
  result = call_597200.call(path_597201, query_597202, nil, nil, nil)

var productPolicyListByProduct* = Call_ProductPolicyListByProduct_597191(
    name: "productPolicyListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies",
    validator: validate_ProductPolicyListByProduct_597192, base: "",
    url: url_ProductPolicyListByProduct_597193, schemes: {Scheme.Https})
type
  Call_ProductPolicyCreateOrUpdate_597229 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyCreateOrUpdate_597231(protocol: Scheme; host: string;
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

proc validate_ProductPolicyCreateOrUpdate_597230(path: JsonNode; query: JsonNode;
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
  var valid_597232 = path.getOrDefault("resourceGroupName")
  valid_597232 = validateParameter(valid_597232, JString, required = true,
                                 default = nil)
  if valid_597232 != nil:
    section.add "resourceGroupName", valid_597232
  var valid_597233 = path.getOrDefault("subscriptionId")
  valid_597233 = validateParameter(valid_597233, JString, required = true,
                                 default = nil)
  if valid_597233 != nil:
    section.add "subscriptionId", valid_597233
  var valid_597234 = path.getOrDefault("policyId")
  valid_597234 = validateParameter(valid_597234, JString, required = true,
                                 default = newJString("policy"))
  if valid_597234 != nil:
    section.add "policyId", valid_597234
  var valid_597235 = path.getOrDefault("productId")
  valid_597235 = validateParameter(valid_597235, JString, required = true,
                                 default = nil)
  if valid_597235 != nil:
    section.add "productId", valid_597235
  var valid_597236 = path.getOrDefault("serviceName")
  valid_597236 = validateParameter(valid_597236, JString, required = true,
                                 default = nil)
  if valid_597236 != nil:
    section.add "serviceName", valid_597236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597237 = query.getOrDefault("api-version")
  valid_597237 = validateParameter(valid_597237, JString, required = true,
                                 default = nil)
  if valid_597237 != nil:
    section.add "api-version", valid_597237
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597238 = header.getOrDefault("If-Match")
  valid_597238 = validateParameter(valid_597238, JString, required = false,
                                 default = nil)
  if valid_597238 != nil:
    section.add "If-Match", valid_597238
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

proc call*(call_597240: Call_ProductPolicyCreateOrUpdate_597229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the Product.
  ## 
  let valid = call_597240.validator(path, query, header, formData, body)
  let scheme = call_597240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597240.url(scheme.get, call_597240.host, call_597240.base,
                         call_597240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597240, url, valid)

proc call*(call_597241: Call_ProductPolicyCreateOrUpdate_597229;
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
  var path_597242 = newJObject()
  var query_597243 = newJObject()
  var body_597244 = newJObject()
  add(path_597242, "resourceGroupName", newJString(resourceGroupName))
  add(query_597243, "api-version", newJString(apiVersion))
  add(path_597242, "subscriptionId", newJString(subscriptionId))
  add(path_597242, "policyId", newJString(policyId))
  if parameters != nil:
    body_597244 = parameters
  add(path_597242, "productId", newJString(productId))
  add(path_597242, "serviceName", newJString(serviceName))
  result = call_597241.call(path_597242, query_597243, nil, nil, body_597244)

var productPolicyCreateOrUpdate* = Call_ProductPolicyCreateOrUpdate_597229(
    name: "productPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyCreateOrUpdate_597230, base: "",
    url: url_ProductPolicyCreateOrUpdate_597231, schemes: {Scheme.Https})
type
  Call_ProductPolicyGetEntityTag_597259 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyGetEntityTag_597261(protocol: Scheme; host: string;
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

proc validate_ProductPolicyGetEntityTag_597260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the ETag of the policy configuration at the Product level.
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
  var valid_597262 = path.getOrDefault("resourceGroupName")
  valid_597262 = validateParameter(valid_597262, JString, required = true,
                                 default = nil)
  if valid_597262 != nil:
    section.add "resourceGroupName", valid_597262
  var valid_597263 = path.getOrDefault("subscriptionId")
  valid_597263 = validateParameter(valid_597263, JString, required = true,
                                 default = nil)
  if valid_597263 != nil:
    section.add "subscriptionId", valid_597263
  var valid_597264 = path.getOrDefault("policyId")
  valid_597264 = validateParameter(valid_597264, JString, required = true,
                                 default = newJString("policy"))
  if valid_597264 != nil:
    section.add "policyId", valid_597264
  var valid_597265 = path.getOrDefault("productId")
  valid_597265 = validateParameter(valid_597265, JString, required = true,
                                 default = nil)
  if valid_597265 != nil:
    section.add "productId", valid_597265
  var valid_597266 = path.getOrDefault("serviceName")
  valid_597266 = validateParameter(valid_597266, JString, required = true,
                                 default = nil)
  if valid_597266 != nil:
    section.add "serviceName", valid_597266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597267 = query.getOrDefault("api-version")
  valid_597267 = validateParameter(valid_597267, JString, required = true,
                                 default = nil)
  if valid_597267 != nil:
    section.add "api-version", valid_597267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597268: Call_ProductPolicyGetEntityTag_597259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the ETag of the policy configuration at the Product level.
  ## 
  let valid = call_597268.validator(path, query, header, formData, body)
  let scheme = call_597268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597268.url(scheme.get, call_597268.host, call_597268.base,
                         call_597268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597268, url, valid)

proc call*(call_597269: Call_ProductPolicyGetEntityTag_597259;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string; policyId: string = "policy"): Recallable =
  ## productPolicyGetEntityTag
  ## Get the ETag of the policy configuration at the Product level.
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
  var path_597270 = newJObject()
  var query_597271 = newJObject()
  add(path_597270, "resourceGroupName", newJString(resourceGroupName))
  add(query_597271, "api-version", newJString(apiVersion))
  add(path_597270, "subscriptionId", newJString(subscriptionId))
  add(path_597270, "policyId", newJString(policyId))
  add(path_597270, "productId", newJString(productId))
  add(path_597270, "serviceName", newJString(serviceName))
  result = call_597269.call(path_597270, query_597271, nil, nil, nil)

var productPolicyGetEntityTag* = Call_ProductPolicyGetEntityTag_597259(
    name: "productPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyGetEntityTag_597260, base: "",
    url: url_ProductPolicyGetEntityTag_597261, schemes: {Scheme.Https})
type
  Call_ProductPolicyGet_597203 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyGet_597205(protocol: Scheme; host: string; base: string;
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

proc validate_ProductPolicyGet_597204(path: JsonNode; query: JsonNode;
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
  var valid_597206 = path.getOrDefault("resourceGroupName")
  valid_597206 = validateParameter(valid_597206, JString, required = true,
                                 default = nil)
  if valid_597206 != nil:
    section.add "resourceGroupName", valid_597206
  var valid_597207 = path.getOrDefault("subscriptionId")
  valid_597207 = validateParameter(valid_597207, JString, required = true,
                                 default = nil)
  if valid_597207 != nil:
    section.add "subscriptionId", valid_597207
  var valid_597221 = path.getOrDefault("policyId")
  valid_597221 = validateParameter(valid_597221, JString, required = true,
                                 default = newJString("policy"))
  if valid_597221 != nil:
    section.add "policyId", valid_597221
  var valid_597222 = path.getOrDefault("productId")
  valid_597222 = validateParameter(valid_597222, JString, required = true,
                                 default = nil)
  if valid_597222 != nil:
    section.add "productId", valid_597222
  var valid_597223 = path.getOrDefault("serviceName")
  valid_597223 = validateParameter(valid_597223, JString, required = true,
                                 default = nil)
  if valid_597223 != nil:
    section.add "serviceName", valid_597223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597224 = query.getOrDefault("api-version")
  valid_597224 = validateParameter(valid_597224, JString, required = true,
                                 default = nil)
  if valid_597224 != nil:
    section.add "api-version", valid_597224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597225: Call_ProductPolicyGet_597203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_597225.validator(path, query, header, formData, body)
  let scheme = call_597225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597225.url(scheme.get, call_597225.host, call_597225.base,
                         call_597225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597225, url, valid)

proc call*(call_597226: Call_ProductPolicyGet_597203; resourceGroupName: string;
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
  var path_597227 = newJObject()
  var query_597228 = newJObject()
  add(path_597227, "resourceGroupName", newJString(resourceGroupName))
  add(query_597228, "api-version", newJString(apiVersion))
  add(path_597227, "subscriptionId", newJString(subscriptionId))
  add(path_597227, "policyId", newJString(policyId))
  add(path_597227, "productId", newJString(productId))
  add(path_597227, "serviceName", newJString(serviceName))
  result = call_597226.call(path_597227, query_597228, nil, nil, nil)

var productPolicyGet* = Call_ProductPolicyGet_597203(name: "productPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyGet_597204, base: "",
    url: url_ProductPolicyGet_597205, schemes: {Scheme.Https})
type
  Call_ProductPolicyDelete_597245 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyDelete_597247(protocol: Scheme; host: string; base: string;
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

proc validate_ProductPolicyDelete_597246(path: JsonNode; query: JsonNode;
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
  var valid_597248 = path.getOrDefault("resourceGroupName")
  valid_597248 = validateParameter(valid_597248, JString, required = true,
                                 default = nil)
  if valid_597248 != nil:
    section.add "resourceGroupName", valid_597248
  var valid_597249 = path.getOrDefault("subscriptionId")
  valid_597249 = validateParameter(valid_597249, JString, required = true,
                                 default = nil)
  if valid_597249 != nil:
    section.add "subscriptionId", valid_597249
  var valid_597250 = path.getOrDefault("policyId")
  valid_597250 = validateParameter(valid_597250, JString, required = true,
                                 default = newJString("policy"))
  if valid_597250 != nil:
    section.add "policyId", valid_597250
  var valid_597251 = path.getOrDefault("productId")
  valid_597251 = validateParameter(valid_597251, JString, required = true,
                                 default = nil)
  if valid_597251 != nil:
    section.add "productId", valid_597251
  var valid_597252 = path.getOrDefault("serviceName")
  valid_597252 = validateParameter(valid_597252, JString, required = true,
                                 default = nil)
  if valid_597252 != nil:
    section.add "serviceName", valid_597252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597253 = query.getOrDefault("api-version")
  valid_597253 = validateParameter(valid_597253, JString, required = true,
                                 default = nil)
  if valid_597253 != nil:
    section.add "api-version", valid_597253
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597254 = header.getOrDefault("If-Match")
  valid_597254 = validateParameter(valid_597254, JString, required = true,
                                 default = nil)
  if valid_597254 != nil:
    section.add "If-Match", valid_597254
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597255: Call_ProductPolicyDelete_597245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Product.
  ## 
  let valid = call_597255.validator(path, query, header, formData, body)
  let scheme = call_597255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597255.url(scheme.get, call_597255.host, call_597255.base,
                         call_597255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597255, url, valid)

proc call*(call_597256: Call_ProductPolicyDelete_597245; resourceGroupName: string;
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
  var path_597257 = newJObject()
  var query_597258 = newJObject()
  add(path_597257, "resourceGroupName", newJString(resourceGroupName))
  add(query_597258, "api-version", newJString(apiVersion))
  add(path_597257, "subscriptionId", newJString(subscriptionId))
  add(path_597257, "policyId", newJString(policyId))
  add(path_597257, "productId", newJString(productId))
  add(path_597257, "serviceName", newJString(serviceName))
  result = call_597256.call(path_597257, query_597258, nil, nil, nil)

var productPolicyDelete* = Call_ProductPolicyDelete_597245(
    name: "productPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyDelete_597246, base: "",
    url: url_ProductPolicyDelete_597247, schemes: {Scheme.Https})
type
  Call_ProductSubscriptionsList_597272 = ref object of OpenApiRestCall_596457
proc url_ProductSubscriptionsList_597274(protocol: Scheme; host: string;
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

proc validate_ProductSubscriptionsList_597273(path: JsonNode; query: JsonNode;
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
  var valid_597275 = path.getOrDefault("resourceGroupName")
  valid_597275 = validateParameter(valid_597275, JString, required = true,
                                 default = nil)
  if valid_597275 != nil:
    section.add "resourceGroupName", valid_597275
  var valid_597276 = path.getOrDefault("subscriptionId")
  valid_597276 = validateParameter(valid_597276, JString, required = true,
                                 default = nil)
  if valid_597276 != nil:
    section.add "subscriptionId", valid_597276
  var valid_597277 = path.getOrDefault("productId")
  valid_597277 = validateParameter(valid_597277, JString, required = true,
                                 default = nil)
  if valid_597277 != nil:
    section.add "productId", valid_597277
  var valid_597278 = path.getOrDefault("serviceName")
  valid_597278 = validateParameter(valid_597278, JString, required = true,
                                 default = nil)
  if valid_597278 != nil:
    section.add "serviceName", valid_597278
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
  var valid_597279 = query.getOrDefault("api-version")
  valid_597279 = validateParameter(valid_597279, JString, required = true,
                                 default = nil)
  if valid_597279 != nil:
    section.add "api-version", valid_597279
  var valid_597280 = query.getOrDefault("$top")
  valid_597280 = validateParameter(valid_597280, JInt, required = false, default = nil)
  if valid_597280 != nil:
    section.add "$top", valid_597280
  var valid_597281 = query.getOrDefault("$skip")
  valid_597281 = validateParameter(valid_597281, JInt, required = false, default = nil)
  if valid_597281 != nil:
    section.add "$skip", valid_597281
  var valid_597282 = query.getOrDefault("$filter")
  valid_597282 = validateParameter(valid_597282, JString, required = false,
                                 default = nil)
  if valid_597282 != nil:
    section.add "$filter", valid_597282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597283: Call_ProductSubscriptionsList_597272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  let valid = call_597283.validator(path, query, header, formData, body)
  let scheme = call_597283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597283.url(scheme.get, call_597283.host, call_597283.base,
                         call_597283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597283, url, valid)

proc call*(call_597284: Call_ProductSubscriptionsList_597272;
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
  var path_597285 = newJObject()
  var query_597286 = newJObject()
  add(path_597285, "resourceGroupName", newJString(resourceGroupName))
  add(query_597286, "api-version", newJString(apiVersion))
  add(path_597285, "subscriptionId", newJString(subscriptionId))
  add(query_597286, "$top", newJInt(Top))
  add(query_597286, "$skip", newJInt(Skip))
  add(path_597285, "productId", newJString(productId))
  add(path_597285, "serviceName", newJString(serviceName))
  add(query_597286, "$filter", newJString(Filter))
  result = call_597284.call(path_597285, query_597286, nil, nil, nil)

var productSubscriptionsList* = Call_ProductSubscriptionsList_597272(
    name: "productSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/subscriptions",
    validator: validate_ProductSubscriptionsList_597273, base: "",
    url: url_ProductSubscriptionsList_597274, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
