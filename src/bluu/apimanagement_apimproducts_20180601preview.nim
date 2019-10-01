
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
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
  ##   tags: JString
  ##       : Products which are part of a specific tag.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |terms | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## |groups |     |    |
  ## 
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
  var valid_596849 = query.getOrDefault("tags")
  valid_596849 = validateParameter(valid_596849, JString, required = false,
                                 default = nil)
  if valid_596849 != nil:
    section.add "tags", valid_596849
  var valid_596850 = query.getOrDefault("$filter")
  valid_596850 = validateParameter(valid_596850, JString, required = false,
                                 default = nil)
  if valid_596850 != nil:
    section.add "$filter", valid_596850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596877: Call_ProductListByService_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of products in the specified service instance.
  ## 
  let valid = call_596877.validator(path, query, header, formData, body)
  let scheme = call_596877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596877.url(scheme.get, call_596877.host, call_596877.base,
                         call_596877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596877, url, valid)

proc call*(call_596948: Call_ProductListByService_596679;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; expandGroups: bool = false;
          tags: string = ""; Filter: string = ""): Recallable =
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
  ##   tags: string
  ##       : Products which are part of a specific tag.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |terms | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## |groups |     |    |
  ## 
  var path_596949 = newJObject()
  var query_596951 = newJObject()
  add(path_596949, "resourceGroupName", newJString(resourceGroupName))
  add(query_596951, "api-version", newJString(apiVersion))
  add(path_596949, "subscriptionId", newJString(subscriptionId))
  add(query_596951, "$top", newJInt(Top))
  add(query_596951, "$skip", newJInt(Skip))
  add(query_596951, "expandGroups", newJBool(expandGroups))
  add(query_596951, "tags", newJString(tags))
  add(path_596949, "serviceName", newJString(serviceName))
  add(query_596951, "$filter", newJString(Filter))
  result = call_596948.call(path_596949, query_596951, nil, nil, nil)

var productListByService* = Call_ProductListByService_596679(
    name: "productListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products",
    validator: validate_ProductListByService_596680, base: "",
    url: url_ProductListByService_596681, schemes: {Scheme.Https})
type
  Call_ProductCreateOrUpdate_597002 = ref object of OpenApiRestCall_596457
proc url_ProductCreateOrUpdate_597004(protocol: Scheme; host: string; base: string;
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

proc validate_ProductCreateOrUpdate_597003(path: JsonNode; query: JsonNode;
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
  var valid_597032 = path.getOrDefault("resourceGroupName")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "resourceGroupName", valid_597032
  var valid_597033 = path.getOrDefault("subscriptionId")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "subscriptionId", valid_597033
  var valid_597034 = path.getOrDefault("productId")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "productId", valid_597034
  var valid_597035 = path.getOrDefault("serviceName")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "serviceName", valid_597035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597036 = query.getOrDefault("api-version")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "api-version", valid_597036
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597037 = header.getOrDefault("If-Match")
  valid_597037 = validateParameter(valid_597037, JString, required = false,
                                 default = nil)
  if valid_597037 != nil:
    section.add "If-Match", valid_597037
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

proc call*(call_597039: Call_ProductCreateOrUpdate_597002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a product.
  ## 
  let valid = call_597039.validator(path, query, header, formData, body)
  let scheme = call_597039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597039.url(scheme.get, call_597039.host, call_597039.base,
                         call_597039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597039, url, valid)

proc call*(call_597040: Call_ProductCreateOrUpdate_597002;
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
  var path_597041 = newJObject()
  var query_597042 = newJObject()
  var body_597043 = newJObject()
  add(path_597041, "resourceGroupName", newJString(resourceGroupName))
  add(query_597042, "api-version", newJString(apiVersion))
  add(path_597041, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597043 = parameters
  add(path_597041, "productId", newJString(productId))
  add(path_597041, "serviceName", newJString(serviceName))
  result = call_597040.call(path_597041, query_597042, nil, nil, body_597043)

var productCreateOrUpdate* = Call_ProductCreateOrUpdate_597002(
    name: "productCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductCreateOrUpdate_597003, base: "",
    url: url_ProductCreateOrUpdate_597004, schemes: {Scheme.Https})
type
  Call_ProductGetEntityTag_597058 = ref object of OpenApiRestCall_596457
proc url_ProductGetEntityTag_597060(protocol: Scheme; host: string; base: string;
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

proc validate_ProductGetEntityTag_597059(path: JsonNode; query: JsonNode;
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
  var valid_597061 = path.getOrDefault("resourceGroupName")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "resourceGroupName", valid_597061
  var valid_597062 = path.getOrDefault("subscriptionId")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "subscriptionId", valid_597062
  var valid_597063 = path.getOrDefault("productId")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "productId", valid_597063
  var valid_597064 = path.getOrDefault("serviceName")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "serviceName", valid_597064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597065 = query.getOrDefault("api-version")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = nil)
  if valid_597065 != nil:
    section.add "api-version", valid_597065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597066: Call_ProductGetEntityTag_597058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the product specified by its identifier.
  ## 
  let valid = call_597066.validator(path, query, header, formData, body)
  let scheme = call_597066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597066.url(scheme.get, call_597066.host, call_597066.base,
                         call_597066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597066, url, valid)

proc call*(call_597067: Call_ProductGetEntityTag_597058; resourceGroupName: string;
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
  var path_597068 = newJObject()
  var query_597069 = newJObject()
  add(path_597068, "resourceGroupName", newJString(resourceGroupName))
  add(query_597069, "api-version", newJString(apiVersion))
  add(path_597068, "subscriptionId", newJString(subscriptionId))
  add(path_597068, "productId", newJString(productId))
  add(path_597068, "serviceName", newJString(serviceName))
  result = call_597067.call(path_597068, query_597069, nil, nil, nil)

var productGetEntityTag* = Call_ProductGetEntityTag_597058(
    name: "productGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductGetEntityTag_597059, base: "",
    url: url_ProductGetEntityTag_597060, schemes: {Scheme.Https})
type
  Call_ProductGet_596990 = ref object of OpenApiRestCall_596457
proc url_ProductGet_596992(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ProductGet_596991(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_596993 = path.getOrDefault("resourceGroupName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "resourceGroupName", valid_596993
  var valid_596994 = path.getOrDefault("subscriptionId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "subscriptionId", valid_596994
  var valid_596995 = path.getOrDefault("productId")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "productId", valid_596995
  var valid_596996 = path.getOrDefault("serviceName")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "serviceName", valid_596996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596997 = query.getOrDefault("api-version")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "api-version", valid_596997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596998: Call_ProductGet_596990; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the product specified by its identifier.
  ## 
  let valid = call_596998.validator(path, query, header, formData, body)
  let scheme = call_596998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596998.url(scheme.get, call_596998.host, call_596998.base,
                         call_596998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596998, url, valid)

proc call*(call_596999: Call_ProductGet_596990; resourceGroupName: string;
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
  var path_597000 = newJObject()
  var query_597001 = newJObject()
  add(path_597000, "resourceGroupName", newJString(resourceGroupName))
  add(query_597001, "api-version", newJString(apiVersion))
  add(path_597000, "subscriptionId", newJString(subscriptionId))
  add(path_597000, "productId", newJString(productId))
  add(path_597000, "serviceName", newJString(serviceName))
  result = call_596999.call(path_597000, query_597001, nil, nil, nil)

var productGet* = Call_ProductGet_596990(name: "productGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
                                      validator: validate_ProductGet_596991,
                                      base: "", url: url_ProductGet_596992,
                                      schemes: {Scheme.Https})
type
  Call_ProductUpdate_597070 = ref object of OpenApiRestCall_596457
proc url_ProductUpdate_597072(protocol: Scheme; host: string; base: string;
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

proc validate_ProductUpdate_597071(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update existing product details.
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
  var valid_597073 = path.getOrDefault("resourceGroupName")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "resourceGroupName", valid_597073
  var valid_597074 = path.getOrDefault("subscriptionId")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "subscriptionId", valid_597074
  var valid_597075 = path.getOrDefault("productId")
  valid_597075 = validateParameter(valid_597075, JString, required = true,
                                 default = nil)
  if valid_597075 != nil:
    section.add "productId", valid_597075
  var valid_597076 = path.getOrDefault("serviceName")
  valid_597076 = validateParameter(valid_597076, JString, required = true,
                                 default = nil)
  if valid_597076 != nil:
    section.add "serviceName", valid_597076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597077 = query.getOrDefault("api-version")
  valid_597077 = validateParameter(valid_597077, JString, required = true,
                                 default = nil)
  if valid_597077 != nil:
    section.add "api-version", valid_597077
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597078 = header.getOrDefault("If-Match")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "If-Match", valid_597078
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

proc call*(call_597080: Call_ProductUpdate_597070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update existing product details.
  ## 
  let valid = call_597080.validator(path, query, header, formData, body)
  let scheme = call_597080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597080.url(scheme.get, call_597080.host, call_597080.base,
                         call_597080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597080, url, valid)

proc call*(call_597081: Call_ProductUpdate_597070; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          productId: string; serviceName: string): Recallable =
  ## productUpdate
  ## Update existing product details.
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
  var path_597082 = newJObject()
  var query_597083 = newJObject()
  var body_597084 = newJObject()
  add(path_597082, "resourceGroupName", newJString(resourceGroupName))
  add(query_597083, "api-version", newJString(apiVersion))
  add(path_597082, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597084 = parameters
  add(path_597082, "productId", newJString(productId))
  add(path_597082, "serviceName", newJString(serviceName))
  result = call_597081.call(path_597082, query_597083, nil, nil, body_597084)

var productUpdate* = Call_ProductUpdate_597070(name: "productUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductUpdate_597071, base: "", url: url_ProductUpdate_597072,
    schemes: {Scheme.Https})
type
  Call_ProductDelete_597044 = ref object of OpenApiRestCall_596457
proc url_ProductDelete_597046(protocol: Scheme; host: string; base: string;
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

proc validate_ProductDelete_597045(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597047 = path.getOrDefault("resourceGroupName")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "resourceGroupName", valid_597047
  var valid_597048 = path.getOrDefault("subscriptionId")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "subscriptionId", valid_597048
  var valid_597049 = path.getOrDefault("productId")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "productId", valid_597049
  var valid_597050 = path.getOrDefault("serviceName")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "serviceName", valid_597050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Delete existing subscriptions associated with the product or not.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597051 = query.getOrDefault("api-version")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "api-version", valid_597051
  var valid_597052 = query.getOrDefault("deleteSubscriptions")
  valid_597052 = validateParameter(valid_597052, JBool, required = false, default = nil)
  if valid_597052 != nil:
    section.add "deleteSubscriptions", valid_597052
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597053 = header.getOrDefault("If-Match")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "If-Match", valid_597053
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597054: Call_ProductDelete_597044; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete product.
  ## 
  let valid = call_597054.validator(path, query, header, formData, body)
  let scheme = call_597054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597054.url(scheme.get, call_597054.host, call_597054.base,
                         call_597054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597054, url, valid)

proc call*(call_597055: Call_ProductDelete_597044; resourceGroupName: string;
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
  var path_597056 = newJObject()
  var query_597057 = newJObject()
  add(path_597056, "resourceGroupName", newJString(resourceGroupName))
  add(query_597057, "api-version", newJString(apiVersion))
  add(path_597056, "subscriptionId", newJString(subscriptionId))
  add(path_597056, "productId", newJString(productId))
  add(path_597056, "serviceName", newJString(serviceName))
  add(query_597057, "deleteSubscriptions", newJBool(deleteSubscriptions))
  result = call_597055.call(path_597056, query_597057, nil, nil, nil)

var productDelete* = Call_ProductDelete_597044(name: "productDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductDelete_597045, base: "", url: url_ProductDelete_597046,
    schemes: {Scheme.Https})
type
  Call_ProductApiListByProduct_597085 = ref object of OpenApiRestCall_596457
proc url_ProductApiListByProduct_597087(protocol: Scheme; host: string; base: string;
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

proc validate_ProductApiListByProduct_597086(path: JsonNode; query: JsonNode;
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
  var valid_597088 = path.getOrDefault("resourceGroupName")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "resourceGroupName", valid_597088
  var valid_597089 = path.getOrDefault("subscriptionId")
  valid_597089 = validateParameter(valid_597089, JString, required = true,
                                 default = nil)
  if valid_597089 != nil:
    section.add "subscriptionId", valid_597089
  var valid_597090 = path.getOrDefault("productId")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "productId", valid_597090
  var valid_597091 = path.getOrDefault("serviceName")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "serviceName", valid_597091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |serviceUrl | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |path | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597092 = query.getOrDefault("api-version")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "api-version", valid_597092
  var valid_597093 = query.getOrDefault("$top")
  valid_597093 = validateParameter(valid_597093, JInt, required = false, default = nil)
  if valid_597093 != nil:
    section.add "$top", valid_597093
  var valid_597094 = query.getOrDefault("$skip")
  valid_597094 = validateParameter(valid_597094, JInt, required = false, default = nil)
  if valid_597094 != nil:
    section.add "$skip", valid_597094
  var valid_597095 = query.getOrDefault("$filter")
  valid_597095 = validateParameter(valid_597095, JString, required = false,
                                 default = nil)
  if valid_597095 != nil:
    section.add "$filter", valid_597095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597096: Call_ProductApiListByProduct_597085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the APIs associated with a product.
  ## 
  let valid = call_597096.validator(path, query, header, formData, body)
  let scheme = call_597096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597096.url(scheme.get, call_597096.host, call_597096.base,
                         call_597096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597096, url, valid)

proc call*(call_597097: Call_ProductApiListByProduct_597085;
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
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |serviceUrl | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |path | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_597098 = newJObject()
  var query_597099 = newJObject()
  add(path_597098, "resourceGroupName", newJString(resourceGroupName))
  add(query_597099, "api-version", newJString(apiVersion))
  add(path_597098, "subscriptionId", newJString(subscriptionId))
  add(query_597099, "$top", newJInt(Top))
  add(query_597099, "$skip", newJInt(Skip))
  add(path_597098, "productId", newJString(productId))
  add(path_597098, "serviceName", newJString(serviceName))
  add(query_597099, "$filter", newJString(Filter))
  result = call_597097.call(path_597098, query_597099, nil, nil, nil)

var productApiListByProduct* = Call_ProductApiListByProduct_597085(
    name: "productApiListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis",
    validator: validate_ProductApiListByProduct_597086, base: "",
    url: url_ProductApiListByProduct_597087, schemes: {Scheme.Https})
type
  Call_ProductApiCreateOrUpdate_597100 = ref object of OpenApiRestCall_596457
proc url_ProductApiCreateOrUpdate_597102(protocol: Scheme; host: string;
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

proc validate_ProductApiCreateOrUpdate_597101(path: JsonNode; query: JsonNode;
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
  var valid_597103 = path.getOrDefault("resourceGroupName")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "resourceGroupName", valid_597103
  var valid_597104 = path.getOrDefault("apiId")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = nil)
  if valid_597104 != nil:
    section.add "apiId", valid_597104
  var valid_597105 = path.getOrDefault("subscriptionId")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "subscriptionId", valid_597105
  var valid_597106 = path.getOrDefault("productId")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "productId", valid_597106
  var valid_597107 = path.getOrDefault("serviceName")
  valid_597107 = validateParameter(valid_597107, JString, required = true,
                                 default = nil)
  if valid_597107 != nil:
    section.add "serviceName", valid_597107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597108 = query.getOrDefault("api-version")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "api-version", valid_597108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597109: Call_ProductApiCreateOrUpdate_597100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an API to the specified product.
  ## 
  let valid = call_597109.validator(path, query, header, formData, body)
  let scheme = call_597109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597109.url(scheme.get, call_597109.host, call_597109.base,
                         call_597109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597109, url, valid)

proc call*(call_597110: Call_ProductApiCreateOrUpdate_597100;
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
  var path_597111 = newJObject()
  var query_597112 = newJObject()
  add(path_597111, "resourceGroupName", newJString(resourceGroupName))
  add(query_597112, "api-version", newJString(apiVersion))
  add(path_597111, "apiId", newJString(apiId))
  add(path_597111, "subscriptionId", newJString(subscriptionId))
  add(path_597111, "productId", newJString(productId))
  add(path_597111, "serviceName", newJString(serviceName))
  result = call_597110.call(path_597111, query_597112, nil, nil, nil)

var productApiCreateOrUpdate* = Call_ProductApiCreateOrUpdate_597100(
    name: "productApiCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiCreateOrUpdate_597101, base: "",
    url: url_ProductApiCreateOrUpdate_597102, schemes: {Scheme.Https})
type
  Call_ProductApiCheckEntityExists_597126 = ref object of OpenApiRestCall_596457
proc url_ProductApiCheckEntityExists_597128(protocol: Scheme; host: string;
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

proc validate_ProductApiCheckEntityExists_597127(path: JsonNode; query: JsonNode;
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
  var valid_597129 = path.getOrDefault("resourceGroupName")
  valid_597129 = validateParameter(valid_597129, JString, required = true,
                                 default = nil)
  if valid_597129 != nil:
    section.add "resourceGroupName", valid_597129
  var valid_597130 = path.getOrDefault("apiId")
  valid_597130 = validateParameter(valid_597130, JString, required = true,
                                 default = nil)
  if valid_597130 != nil:
    section.add "apiId", valid_597130
  var valid_597131 = path.getOrDefault("subscriptionId")
  valid_597131 = validateParameter(valid_597131, JString, required = true,
                                 default = nil)
  if valid_597131 != nil:
    section.add "subscriptionId", valid_597131
  var valid_597132 = path.getOrDefault("productId")
  valid_597132 = validateParameter(valid_597132, JString, required = true,
                                 default = nil)
  if valid_597132 != nil:
    section.add "productId", valid_597132
  var valid_597133 = path.getOrDefault("serviceName")
  valid_597133 = validateParameter(valid_597133, JString, required = true,
                                 default = nil)
  if valid_597133 != nil:
    section.add "serviceName", valid_597133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597134 = query.getOrDefault("api-version")
  valid_597134 = validateParameter(valid_597134, JString, required = true,
                                 default = nil)
  if valid_597134 != nil:
    section.add "api-version", valid_597134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597135: Call_ProductApiCheckEntityExists_597126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that API entity specified by identifier is associated with the Product entity.
  ## 
  let valid = call_597135.validator(path, query, header, formData, body)
  let scheme = call_597135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597135.url(scheme.get, call_597135.host, call_597135.base,
                         call_597135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597135, url, valid)

proc call*(call_597136: Call_ProductApiCheckEntityExists_597126;
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
  var path_597137 = newJObject()
  var query_597138 = newJObject()
  add(path_597137, "resourceGroupName", newJString(resourceGroupName))
  add(query_597138, "api-version", newJString(apiVersion))
  add(path_597137, "apiId", newJString(apiId))
  add(path_597137, "subscriptionId", newJString(subscriptionId))
  add(path_597137, "productId", newJString(productId))
  add(path_597137, "serviceName", newJString(serviceName))
  result = call_597136.call(path_597137, query_597138, nil, nil, nil)

var productApiCheckEntityExists* = Call_ProductApiCheckEntityExists_597126(
    name: "productApiCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiCheckEntityExists_597127, base: "",
    url: url_ProductApiCheckEntityExists_597128, schemes: {Scheme.Https})
type
  Call_ProductApiDelete_597113 = ref object of OpenApiRestCall_596457
proc url_ProductApiDelete_597115(protocol: Scheme; host: string; base: string;
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

proc validate_ProductApiDelete_597114(path: JsonNode; query: JsonNode;
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
  var valid_597116 = path.getOrDefault("resourceGroupName")
  valid_597116 = validateParameter(valid_597116, JString, required = true,
                                 default = nil)
  if valid_597116 != nil:
    section.add "resourceGroupName", valid_597116
  var valid_597117 = path.getOrDefault("apiId")
  valid_597117 = validateParameter(valid_597117, JString, required = true,
                                 default = nil)
  if valid_597117 != nil:
    section.add "apiId", valid_597117
  var valid_597118 = path.getOrDefault("subscriptionId")
  valid_597118 = validateParameter(valid_597118, JString, required = true,
                                 default = nil)
  if valid_597118 != nil:
    section.add "subscriptionId", valid_597118
  var valid_597119 = path.getOrDefault("productId")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "productId", valid_597119
  var valid_597120 = path.getOrDefault("serviceName")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "serviceName", valid_597120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597121 = query.getOrDefault("api-version")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = nil)
  if valid_597121 != nil:
    section.add "api-version", valid_597121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597122: Call_ProductApiDelete_597113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API from the specified product.
  ## 
  let valid = call_597122.validator(path, query, header, formData, body)
  let scheme = call_597122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597122.url(scheme.get, call_597122.host, call_597122.base,
                         call_597122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597122, url, valid)

proc call*(call_597123: Call_ProductApiDelete_597113; resourceGroupName: string;
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
  var path_597124 = newJObject()
  var query_597125 = newJObject()
  add(path_597124, "resourceGroupName", newJString(resourceGroupName))
  add(query_597125, "api-version", newJString(apiVersion))
  add(path_597124, "apiId", newJString(apiId))
  add(path_597124, "subscriptionId", newJString(subscriptionId))
  add(path_597124, "productId", newJString(productId))
  add(path_597124, "serviceName", newJString(serviceName))
  result = call_597123.call(path_597124, query_597125, nil, nil, nil)

var productApiDelete* = Call_ProductApiDelete_597113(name: "productApiDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApiDelete_597114, base: "",
    url: url_ProductApiDelete_597115, schemes: {Scheme.Https})
type
  Call_ProductGroupListByProduct_597139 = ref object of OpenApiRestCall_596457
proc url_ProductGroupListByProduct_597141(protocol: Scheme; host: string;
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

proc validate_ProductGroupListByProduct_597140(path: JsonNode; query: JsonNode;
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
  var valid_597142 = path.getOrDefault("resourceGroupName")
  valid_597142 = validateParameter(valid_597142, JString, required = true,
                                 default = nil)
  if valid_597142 != nil:
    section.add "resourceGroupName", valid_597142
  var valid_597143 = path.getOrDefault("subscriptionId")
  valid_597143 = validateParameter(valid_597143, JString, required = true,
                                 default = nil)
  if valid_597143 != nil:
    section.add "subscriptionId", valid_597143
  var valid_597144 = path.getOrDefault("productId")
  valid_597144 = validateParameter(valid_597144, JString, required = true,
                                 default = nil)
  if valid_597144 != nil:
    section.add "productId", valid_597144
  var valid_597145 = path.getOrDefault("serviceName")
  valid_597145 = validateParameter(valid_597145, JString, required = true,
                                 default = nil)
  if valid_597145 != nil:
    section.add "serviceName", valid_597145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt |    |
  ## |displayName | eq, ne |    |
  ## |description | eq, ne |    |
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597146 = query.getOrDefault("api-version")
  valid_597146 = validateParameter(valid_597146, JString, required = true,
                                 default = nil)
  if valid_597146 != nil:
    section.add "api-version", valid_597146
  var valid_597147 = query.getOrDefault("$top")
  valid_597147 = validateParameter(valid_597147, JInt, required = false, default = nil)
  if valid_597147 != nil:
    section.add "$top", valid_597147
  var valid_597148 = query.getOrDefault("$skip")
  valid_597148 = validateParameter(valid_597148, JInt, required = false, default = nil)
  if valid_597148 != nil:
    section.add "$skip", valid_597148
  var valid_597149 = query.getOrDefault("$filter")
  valid_597149 = validateParameter(valid_597149, JString, required = false,
                                 default = nil)
  if valid_597149 != nil:
    section.add "$filter", valid_597149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597150: Call_ProductGroupListByProduct_597139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  let valid = call_597150.validator(path, query, header, formData, body)
  let scheme = call_597150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597150.url(scheme.get, call_597150.host, call_597150.base,
                         call_597150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597150, url, valid)

proc call*(call_597151: Call_ProductGroupListByProduct_597139;
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
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt |    |
  ## |displayName | eq, ne |    |
  ## |description | eq, ne |    |
  ## 
  var path_597152 = newJObject()
  var query_597153 = newJObject()
  add(path_597152, "resourceGroupName", newJString(resourceGroupName))
  add(query_597153, "api-version", newJString(apiVersion))
  add(path_597152, "subscriptionId", newJString(subscriptionId))
  add(query_597153, "$top", newJInt(Top))
  add(query_597153, "$skip", newJInt(Skip))
  add(path_597152, "productId", newJString(productId))
  add(path_597152, "serviceName", newJString(serviceName))
  add(query_597153, "$filter", newJString(Filter))
  result = call_597151.call(path_597152, query_597153, nil, nil, nil)

var productGroupListByProduct* = Call_ProductGroupListByProduct_597139(
    name: "productGroupListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups",
    validator: validate_ProductGroupListByProduct_597140, base: "",
    url: url_ProductGroupListByProduct_597141, schemes: {Scheme.Https})
type
  Call_ProductGroupCreateOrUpdate_597154 = ref object of OpenApiRestCall_596457
proc url_ProductGroupCreateOrUpdate_597156(protocol: Scheme; host: string;
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

proc validate_ProductGroupCreateOrUpdate_597155(path: JsonNode; query: JsonNode;
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
  var valid_597157 = path.getOrDefault("groupId")
  valid_597157 = validateParameter(valid_597157, JString, required = true,
                                 default = nil)
  if valid_597157 != nil:
    section.add "groupId", valid_597157
  var valid_597158 = path.getOrDefault("resourceGroupName")
  valid_597158 = validateParameter(valid_597158, JString, required = true,
                                 default = nil)
  if valid_597158 != nil:
    section.add "resourceGroupName", valid_597158
  var valid_597159 = path.getOrDefault("subscriptionId")
  valid_597159 = validateParameter(valid_597159, JString, required = true,
                                 default = nil)
  if valid_597159 != nil:
    section.add "subscriptionId", valid_597159
  var valid_597160 = path.getOrDefault("productId")
  valid_597160 = validateParameter(valid_597160, JString, required = true,
                                 default = nil)
  if valid_597160 != nil:
    section.add "productId", valid_597160
  var valid_597161 = path.getOrDefault("serviceName")
  valid_597161 = validateParameter(valid_597161, JString, required = true,
                                 default = nil)
  if valid_597161 != nil:
    section.add "serviceName", valid_597161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597162 = query.getOrDefault("api-version")
  valid_597162 = validateParameter(valid_597162, JString, required = true,
                                 default = nil)
  if valid_597162 != nil:
    section.add "api-version", valid_597162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597163: Call_ProductGroupCreateOrUpdate_597154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  let valid = call_597163.validator(path, query, header, formData, body)
  let scheme = call_597163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597163.url(scheme.get, call_597163.host, call_597163.base,
                         call_597163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597163, url, valid)

proc call*(call_597164: Call_ProductGroupCreateOrUpdate_597154; groupId: string;
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
  var path_597165 = newJObject()
  var query_597166 = newJObject()
  add(path_597165, "groupId", newJString(groupId))
  add(path_597165, "resourceGroupName", newJString(resourceGroupName))
  add(query_597166, "api-version", newJString(apiVersion))
  add(path_597165, "subscriptionId", newJString(subscriptionId))
  add(path_597165, "productId", newJString(productId))
  add(path_597165, "serviceName", newJString(serviceName))
  result = call_597164.call(path_597165, query_597166, nil, nil, nil)

var productGroupCreateOrUpdate* = Call_ProductGroupCreateOrUpdate_597154(
    name: "productGroupCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupCreateOrUpdate_597155, base: "",
    url: url_ProductGroupCreateOrUpdate_597156, schemes: {Scheme.Https})
type
  Call_ProductGroupCheckEntityExists_597180 = ref object of OpenApiRestCall_596457
proc url_ProductGroupCheckEntityExists_597182(protocol: Scheme; host: string;
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

proc validate_ProductGroupCheckEntityExists_597181(path: JsonNode; query: JsonNode;
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
  var valid_597183 = path.getOrDefault("groupId")
  valid_597183 = validateParameter(valid_597183, JString, required = true,
                                 default = nil)
  if valid_597183 != nil:
    section.add "groupId", valid_597183
  var valid_597184 = path.getOrDefault("resourceGroupName")
  valid_597184 = validateParameter(valid_597184, JString, required = true,
                                 default = nil)
  if valid_597184 != nil:
    section.add "resourceGroupName", valid_597184
  var valid_597185 = path.getOrDefault("subscriptionId")
  valid_597185 = validateParameter(valid_597185, JString, required = true,
                                 default = nil)
  if valid_597185 != nil:
    section.add "subscriptionId", valid_597185
  var valid_597186 = path.getOrDefault("productId")
  valid_597186 = validateParameter(valid_597186, JString, required = true,
                                 default = nil)
  if valid_597186 != nil:
    section.add "productId", valid_597186
  var valid_597187 = path.getOrDefault("serviceName")
  valid_597187 = validateParameter(valid_597187, JString, required = true,
                                 default = nil)
  if valid_597187 != nil:
    section.add "serviceName", valid_597187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597188 = query.getOrDefault("api-version")
  valid_597188 = validateParameter(valid_597188, JString, required = true,
                                 default = nil)
  if valid_597188 != nil:
    section.add "api-version", valid_597188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597189: Call_ProductGroupCheckEntityExists_597180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that Group entity specified by identifier is associated with the Product entity.
  ## 
  let valid = call_597189.validator(path, query, header, formData, body)
  let scheme = call_597189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597189.url(scheme.get, call_597189.host, call_597189.base,
                         call_597189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597189, url, valid)

proc call*(call_597190: Call_ProductGroupCheckEntityExists_597180; groupId: string;
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
  var path_597191 = newJObject()
  var query_597192 = newJObject()
  add(path_597191, "groupId", newJString(groupId))
  add(path_597191, "resourceGroupName", newJString(resourceGroupName))
  add(query_597192, "api-version", newJString(apiVersion))
  add(path_597191, "subscriptionId", newJString(subscriptionId))
  add(path_597191, "productId", newJString(productId))
  add(path_597191, "serviceName", newJString(serviceName))
  result = call_597190.call(path_597191, query_597192, nil, nil, nil)

var productGroupCheckEntityExists* = Call_ProductGroupCheckEntityExists_597180(
    name: "productGroupCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupCheckEntityExists_597181, base: "",
    url: url_ProductGroupCheckEntityExists_597182, schemes: {Scheme.Https})
type
  Call_ProductGroupDelete_597167 = ref object of OpenApiRestCall_596457
proc url_ProductGroupDelete_597169(protocol: Scheme; host: string; base: string;
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

proc validate_ProductGroupDelete_597168(path: JsonNode; query: JsonNode;
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
  var valid_597170 = path.getOrDefault("groupId")
  valid_597170 = validateParameter(valid_597170, JString, required = true,
                                 default = nil)
  if valid_597170 != nil:
    section.add "groupId", valid_597170
  var valid_597171 = path.getOrDefault("resourceGroupName")
  valid_597171 = validateParameter(valid_597171, JString, required = true,
                                 default = nil)
  if valid_597171 != nil:
    section.add "resourceGroupName", valid_597171
  var valid_597172 = path.getOrDefault("subscriptionId")
  valid_597172 = validateParameter(valid_597172, JString, required = true,
                                 default = nil)
  if valid_597172 != nil:
    section.add "subscriptionId", valid_597172
  var valid_597173 = path.getOrDefault("productId")
  valid_597173 = validateParameter(valid_597173, JString, required = true,
                                 default = nil)
  if valid_597173 != nil:
    section.add "productId", valid_597173
  var valid_597174 = path.getOrDefault("serviceName")
  valid_597174 = validateParameter(valid_597174, JString, required = true,
                                 default = nil)
  if valid_597174 != nil:
    section.add "serviceName", valid_597174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597175 = query.getOrDefault("api-version")
  valid_597175 = validateParameter(valid_597175, JString, required = true,
                                 default = nil)
  if valid_597175 != nil:
    section.add "api-version", valid_597175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597176: Call_ProductGroupDelete_597167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the association between the specified group and product.
  ## 
  let valid = call_597176.validator(path, query, header, formData, body)
  let scheme = call_597176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597176.url(scheme.get, call_597176.host, call_597176.base,
                         call_597176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597176, url, valid)

proc call*(call_597177: Call_ProductGroupDelete_597167; groupId: string;
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
  var path_597178 = newJObject()
  var query_597179 = newJObject()
  add(path_597178, "groupId", newJString(groupId))
  add(path_597178, "resourceGroupName", newJString(resourceGroupName))
  add(query_597179, "api-version", newJString(apiVersion))
  add(path_597178, "subscriptionId", newJString(subscriptionId))
  add(path_597178, "productId", newJString(productId))
  add(path_597178, "serviceName", newJString(serviceName))
  result = call_597177.call(path_597178, query_597179, nil, nil, nil)

var productGroupDelete* = Call_ProductGroupDelete_597167(
    name: "productGroupDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupDelete_597168, base: "",
    url: url_ProductGroupDelete_597169, schemes: {Scheme.Https})
type
  Call_ProductPolicyListByProduct_597193 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyListByProduct_597195(protocol: Scheme; host: string;
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

proc validate_ProductPolicyListByProduct_597194(path: JsonNode; query: JsonNode;
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
  var valid_597196 = path.getOrDefault("resourceGroupName")
  valid_597196 = validateParameter(valid_597196, JString, required = true,
                                 default = nil)
  if valid_597196 != nil:
    section.add "resourceGroupName", valid_597196
  var valid_597197 = path.getOrDefault("subscriptionId")
  valid_597197 = validateParameter(valid_597197, JString, required = true,
                                 default = nil)
  if valid_597197 != nil:
    section.add "subscriptionId", valid_597197
  var valid_597198 = path.getOrDefault("productId")
  valid_597198 = validateParameter(valid_597198, JString, required = true,
                                 default = nil)
  if valid_597198 != nil:
    section.add "productId", valid_597198
  var valid_597199 = path.getOrDefault("serviceName")
  valid_597199 = validateParameter(valid_597199, JString, required = true,
                                 default = nil)
  if valid_597199 != nil:
    section.add "serviceName", valid_597199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597200 = query.getOrDefault("api-version")
  valid_597200 = validateParameter(valid_597200, JString, required = true,
                                 default = nil)
  if valid_597200 != nil:
    section.add "api-version", valid_597200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597201: Call_ProductPolicyListByProduct_597193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_597201.validator(path, query, header, formData, body)
  let scheme = call_597201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597201.url(scheme.get, call_597201.host, call_597201.base,
                         call_597201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597201, url, valid)

proc call*(call_597202: Call_ProductPolicyListByProduct_597193;
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
  var path_597203 = newJObject()
  var query_597204 = newJObject()
  add(path_597203, "resourceGroupName", newJString(resourceGroupName))
  add(query_597204, "api-version", newJString(apiVersion))
  add(path_597203, "subscriptionId", newJString(subscriptionId))
  add(path_597203, "productId", newJString(productId))
  add(path_597203, "serviceName", newJString(serviceName))
  result = call_597202.call(path_597203, query_597204, nil, nil, nil)

var productPolicyListByProduct* = Call_ProductPolicyListByProduct_597193(
    name: "productPolicyListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies",
    validator: validate_ProductPolicyListByProduct_597194, base: "",
    url: url_ProductPolicyListByProduct_597195, schemes: {Scheme.Https})
type
  Call_ProductPolicyCreateOrUpdate_597231 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyCreateOrUpdate_597233(protocol: Scheme; host: string;
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

proc validate_ProductPolicyCreateOrUpdate_597232(path: JsonNode; query: JsonNode;
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
  var valid_597234 = path.getOrDefault("resourceGroupName")
  valid_597234 = validateParameter(valid_597234, JString, required = true,
                                 default = nil)
  if valid_597234 != nil:
    section.add "resourceGroupName", valid_597234
  var valid_597235 = path.getOrDefault("subscriptionId")
  valid_597235 = validateParameter(valid_597235, JString, required = true,
                                 default = nil)
  if valid_597235 != nil:
    section.add "subscriptionId", valid_597235
  var valid_597236 = path.getOrDefault("policyId")
  valid_597236 = validateParameter(valid_597236, JString, required = true,
                                 default = newJString("policy"))
  if valid_597236 != nil:
    section.add "policyId", valid_597236
  var valid_597237 = path.getOrDefault("productId")
  valid_597237 = validateParameter(valid_597237, JString, required = true,
                                 default = nil)
  if valid_597237 != nil:
    section.add "productId", valid_597237
  var valid_597238 = path.getOrDefault("serviceName")
  valid_597238 = validateParameter(valid_597238, JString, required = true,
                                 default = nil)
  if valid_597238 != nil:
    section.add "serviceName", valid_597238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597239 = query.getOrDefault("api-version")
  valid_597239 = validateParameter(valid_597239, JString, required = true,
                                 default = nil)
  if valid_597239 != nil:
    section.add "api-version", valid_597239
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597240 = header.getOrDefault("If-Match")
  valid_597240 = validateParameter(valid_597240, JString, required = false,
                                 default = nil)
  if valid_597240 != nil:
    section.add "If-Match", valid_597240
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

proc call*(call_597242: Call_ProductPolicyCreateOrUpdate_597231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the Product.
  ## 
  let valid = call_597242.validator(path, query, header, formData, body)
  let scheme = call_597242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597242.url(scheme.get, call_597242.host, call_597242.base,
                         call_597242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597242, url, valid)

proc call*(call_597243: Call_ProductPolicyCreateOrUpdate_597231;
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
  var path_597244 = newJObject()
  var query_597245 = newJObject()
  var body_597246 = newJObject()
  add(path_597244, "resourceGroupName", newJString(resourceGroupName))
  add(query_597245, "api-version", newJString(apiVersion))
  add(path_597244, "subscriptionId", newJString(subscriptionId))
  add(path_597244, "policyId", newJString(policyId))
  if parameters != nil:
    body_597246 = parameters
  add(path_597244, "productId", newJString(productId))
  add(path_597244, "serviceName", newJString(serviceName))
  result = call_597243.call(path_597244, query_597245, nil, nil, body_597246)

var productPolicyCreateOrUpdate* = Call_ProductPolicyCreateOrUpdate_597231(
    name: "productPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyCreateOrUpdate_597232, base: "",
    url: url_ProductPolicyCreateOrUpdate_597233, schemes: {Scheme.Https})
type
  Call_ProductPolicyGetEntityTag_597261 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyGetEntityTag_597263(protocol: Scheme; host: string;
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

proc validate_ProductPolicyGetEntityTag_597262(path: JsonNode; query: JsonNode;
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
  var valid_597264 = path.getOrDefault("resourceGroupName")
  valid_597264 = validateParameter(valid_597264, JString, required = true,
                                 default = nil)
  if valid_597264 != nil:
    section.add "resourceGroupName", valid_597264
  var valid_597265 = path.getOrDefault("subscriptionId")
  valid_597265 = validateParameter(valid_597265, JString, required = true,
                                 default = nil)
  if valid_597265 != nil:
    section.add "subscriptionId", valid_597265
  var valid_597266 = path.getOrDefault("policyId")
  valid_597266 = validateParameter(valid_597266, JString, required = true,
                                 default = newJString("policy"))
  if valid_597266 != nil:
    section.add "policyId", valid_597266
  var valid_597267 = path.getOrDefault("productId")
  valid_597267 = validateParameter(valid_597267, JString, required = true,
                                 default = nil)
  if valid_597267 != nil:
    section.add "productId", valid_597267
  var valid_597268 = path.getOrDefault("serviceName")
  valid_597268 = validateParameter(valid_597268, JString, required = true,
                                 default = nil)
  if valid_597268 != nil:
    section.add "serviceName", valid_597268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597269 = query.getOrDefault("api-version")
  valid_597269 = validateParameter(valid_597269, JString, required = true,
                                 default = nil)
  if valid_597269 != nil:
    section.add "api-version", valid_597269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597270: Call_ProductPolicyGetEntityTag_597261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the ETag of the policy configuration at the Product level.
  ## 
  let valid = call_597270.validator(path, query, header, formData, body)
  let scheme = call_597270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597270.url(scheme.get, call_597270.host, call_597270.base,
                         call_597270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597270, url, valid)

proc call*(call_597271: Call_ProductPolicyGetEntityTag_597261;
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
  var path_597272 = newJObject()
  var query_597273 = newJObject()
  add(path_597272, "resourceGroupName", newJString(resourceGroupName))
  add(query_597273, "api-version", newJString(apiVersion))
  add(path_597272, "subscriptionId", newJString(subscriptionId))
  add(path_597272, "policyId", newJString(policyId))
  add(path_597272, "productId", newJString(productId))
  add(path_597272, "serviceName", newJString(serviceName))
  result = call_597271.call(path_597272, query_597273, nil, nil, nil)

var productPolicyGetEntityTag* = Call_ProductPolicyGetEntityTag_597261(
    name: "productPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyGetEntityTag_597262, base: "",
    url: url_ProductPolicyGetEntityTag_597263, schemes: {Scheme.Https})
type
  Call_ProductPolicyGet_597205 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyGet_597207(protocol: Scheme; host: string; base: string;
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

proc validate_ProductPolicyGet_597206(path: JsonNode; query: JsonNode;
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
  var valid_597208 = path.getOrDefault("resourceGroupName")
  valid_597208 = validateParameter(valid_597208, JString, required = true,
                                 default = nil)
  if valid_597208 != nil:
    section.add "resourceGroupName", valid_597208
  var valid_597209 = path.getOrDefault("subscriptionId")
  valid_597209 = validateParameter(valid_597209, JString, required = true,
                                 default = nil)
  if valid_597209 != nil:
    section.add "subscriptionId", valid_597209
  var valid_597223 = path.getOrDefault("policyId")
  valid_597223 = validateParameter(valid_597223, JString, required = true,
                                 default = newJString("policy"))
  if valid_597223 != nil:
    section.add "policyId", valid_597223
  var valid_597224 = path.getOrDefault("productId")
  valid_597224 = validateParameter(valid_597224, JString, required = true,
                                 default = nil)
  if valid_597224 != nil:
    section.add "productId", valid_597224
  var valid_597225 = path.getOrDefault("serviceName")
  valid_597225 = validateParameter(valid_597225, JString, required = true,
                                 default = nil)
  if valid_597225 != nil:
    section.add "serviceName", valid_597225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597226 = query.getOrDefault("api-version")
  valid_597226 = validateParameter(valid_597226, JString, required = true,
                                 default = nil)
  if valid_597226 != nil:
    section.add "api-version", valid_597226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597227: Call_ProductPolicyGet_597205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the Product level.
  ## 
  let valid = call_597227.validator(path, query, header, formData, body)
  let scheme = call_597227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597227.url(scheme.get, call_597227.host, call_597227.base,
                         call_597227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597227, url, valid)

proc call*(call_597228: Call_ProductPolicyGet_597205; resourceGroupName: string;
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
  var path_597229 = newJObject()
  var query_597230 = newJObject()
  add(path_597229, "resourceGroupName", newJString(resourceGroupName))
  add(query_597230, "api-version", newJString(apiVersion))
  add(path_597229, "subscriptionId", newJString(subscriptionId))
  add(path_597229, "policyId", newJString(policyId))
  add(path_597229, "productId", newJString(productId))
  add(path_597229, "serviceName", newJString(serviceName))
  result = call_597228.call(path_597229, query_597230, nil, nil, nil)

var productPolicyGet* = Call_ProductPolicyGet_597205(name: "productPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyGet_597206, base: "",
    url: url_ProductPolicyGet_597207, schemes: {Scheme.Https})
type
  Call_ProductPolicyDelete_597247 = ref object of OpenApiRestCall_596457
proc url_ProductPolicyDelete_597249(protocol: Scheme; host: string; base: string;
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

proc validate_ProductPolicyDelete_597248(path: JsonNode; query: JsonNode;
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
  var valid_597250 = path.getOrDefault("resourceGroupName")
  valid_597250 = validateParameter(valid_597250, JString, required = true,
                                 default = nil)
  if valid_597250 != nil:
    section.add "resourceGroupName", valid_597250
  var valid_597251 = path.getOrDefault("subscriptionId")
  valid_597251 = validateParameter(valid_597251, JString, required = true,
                                 default = nil)
  if valid_597251 != nil:
    section.add "subscriptionId", valid_597251
  var valid_597252 = path.getOrDefault("policyId")
  valid_597252 = validateParameter(valid_597252, JString, required = true,
                                 default = newJString("policy"))
  if valid_597252 != nil:
    section.add "policyId", valid_597252
  var valid_597253 = path.getOrDefault("productId")
  valid_597253 = validateParameter(valid_597253, JString, required = true,
                                 default = nil)
  if valid_597253 != nil:
    section.add "productId", valid_597253
  var valid_597254 = path.getOrDefault("serviceName")
  valid_597254 = validateParameter(valid_597254, JString, required = true,
                                 default = nil)
  if valid_597254 != nil:
    section.add "serviceName", valid_597254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597255 = query.getOrDefault("api-version")
  valid_597255 = validateParameter(valid_597255, JString, required = true,
                                 default = nil)
  if valid_597255 != nil:
    section.add "api-version", valid_597255
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597256 = header.getOrDefault("If-Match")
  valid_597256 = validateParameter(valid_597256, JString, required = true,
                                 default = nil)
  if valid_597256 != nil:
    section.add "If-Match", valid_597256
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597257: Call_ProductPolicyDelete_597247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Product.
  ## 
  let valid = call_597257.validator(path, query, header, formData, body)
  let scheme = call_597257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597257.url(scheme.get, call_597257.host, call_597257.base,
                         call_597257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597257, url, valid)

proc call*(call_597258: Call_ProductPolicyDelete_597247; resourceGroupName: string;
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
  var path_597259 = newJObject()
  var query_597260 = newJObject()
  add(path_597259, "resourceGroupName", newJString(resourceGroupName))
  add(query_597260, "api-version", newJString(apiVersion))
  add(path_597259, "subscriptionId", newJString(subscriptionId))
  add(path_597259, "policyId", newJString(policyId))
  add(path_597259, "productId", newJString(productId))
  add(path_597259, "serviceName", newJString(serviceName))
  result = call_597258.call(path_597259, query_597260, nil, nil, nil)

var productPolicyDelete* = Call_ProductPolicyDelete_597247(
    name: "productPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/policies/{policyId}",
    validator: validate_ProductPolicyDelete_597248, base: "",
    url: url_ProductPolicyDelete_597249, schemes: {Scheme.Https})
type
  Call_ProductSubscriptionsList_597274 = ref object of OpenApiRestCall_596457
proc url_ProductSubscriptionsList_597276(protocol: Scheme; host: string;
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

proc validate_ProductSubscriptionsList_597275(path: JsonNode; query: JsonNode;
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
  var valid_597277 = path.getOrDefault("resourceGroupName")
  valid_597277 = validateParameter(valid_597277, JString, required = true,
                                 default = nil)
  if valid_597277 != nil:
    section.add "resourceGroupName", valid_597277
  var valid_597278 = path.getOrDefault("subscriptionId")
  valid_597278 = validateParameter(valid_597278, JString, required = true,
                                 default = nil)
  if valid_597278 != nil:
    section.add "subscriptionId", valid_597278
  var valid_597279 = path.getOrDefault("productId")
  valid_597279 = validateParameter(valid_597279, JString, required = true,
                                 default = nil)
  if valid_597279 != nil:
    section.add "productId", valid_597279
  var valid_597280 = path.getOrDefault("serviceName")
  valid_597280 = validateParameter(valid_597280, JString, required = true,
                                 default = nil)
  if valid_597280 != nil:
    section.add "serviceName", valid_597280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |ownerId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |scope | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |productId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## |user |     |    |
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597281 = query.getOrDefault("api-version")
  valid_597281 = validateParameter(valid_597281, JString, required = true,
                                 default = nil)
  if valid_597281 != nil:
    section.add "api-version", valid_597281
  var valid_597282 = query.getOrDefault("$top")
  valid_597282 = validateParameter(valid_597282, JInt, required = false, default = nil)
  if valid_597282 != nil:
    section.add "$top", valid_597282
  var valid_597283 = query.getOrDefault("$skip")
  valid_597283 = validateParameter(valid_597283, JInt, required = false, default = nil)
  if valid_597283 != nil:
    section.add "$skip", valid_597283
  var valid_597284 = query.getOrDefault("$filter")
  valid_597284 = validateParameter(valid_597284, JString, required = false,
                                 default = nil)
  if valid_597284 != nil:
    section.add "$filter", valid_597284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597285: Call_ProductSubscriptionsList_597274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  let valid = call_597285.validator(path, query, header, formData, body)
  let scheme = call_597285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597285.url(scheme.get, call_597285.host, call_597285.base,
                         call_597285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597285, url, valid)

proc call*(call_597286: Call_ProductSubscriptionsList_597274;
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
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |ownerId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |scope | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |productId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## |user |     |    |
  ## 
  var path_597287 = newJObject()
  var query_597288 = newJObject()
  add(path_597287, "resourceGroupName", newJString(resourceGroupName))
  add(query_597288, "api-version", newJString(apiVersion))
  add(path_597287, "subscriptionId", newJString(subscriptionId))
  add(query_597288, "$top", newJInt(Top))
  add(query_597288, "$skip", newJInt(Skip))
  add(path_597287, "productId", newJString(productId))
  add(path_597287, "serviceName", newJString(serviceName))
  add(query_597288, "$filter", newJString(Filter))
  result = call_597286.call(path_597287, query_597288, nil, nil, nil)

var productSubscriptionsList* = Call_ProductSubscriptionsList_597274(
    name: "productSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/subscriptions",
    validator: validate_ProductSubscriptionsList_597275, base: "",
    url: url_ProductSubscriptionsList_597276, schemes: {Scheme.Https})
type
  Call_TagListByProduct_597289 = ref object of OpenApiRestCall_596457
proc url_TagListByProduct_597291(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByProduct_597290(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all Tags associated with the Product.
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
  var valid_597292 = path.getOrDefault("resourceGroupName")
  valid_597292 = validateParameter(valid_597292, JString, required = true,
                                 default = nil)
  if valid_597292 != nil:
    section.add "resourceGroupName", valid_597292
  var valid_597293 = path.getOrDefault("subscriptionId")
  valid_597293 = validateParameter(valid_597293, JString, required = true,
                                 default = nil)
  if valid_597293 != nil:
    section.add "subscriptionId", valid_597293
  var valid_597294 = path.getOrDefault("productId")
  valid_597294 = validateParameter(valid_597294, JString, required = true,
                                 default = nil)
  if valid_597294 != nil:
    section.add "productId", valid_597294
  var valid_597295 = path.getOrDefault("serviceName")
  valid_597295 = validateParameter(valid_597295, JString, required = true,
                                 default = nil)
  if valid_597295 != nil:
    section.add "serviceName", valid_597295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597296 = query.getOrDefault("api-version")
  valid_597296 = validateParameter(valid_597296, JString, required = true,
                                 default = nil)
  if valid_597296 != nil:
    section.add "api-version", valid_597296
  var valid_597297 = query.getOrDefault("$top")
  valid_597297 = validateParameter(valid_597297, JInt, required = false, default = nil)
  if valid_597297 != nil:
    section.add "$top", valid_597297
  var valid_597298 = query.getOrDefault("$skip")
  valid_597298 = validateParameter(valid_597298, JInt, required = false, default = nil)
  if valid_597298 != nil:
    section.add "$skip", valid_597298
  var valid_597299 = query.getOrDefault("$filter")
  valid_597299 = validateParameter(valid_597299, JString, required = false,
                                 default = nil)
  if valid_597299 != nil:
    section.add "$filter", valid_597299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597300: Call_TagListByProduct_597289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the Product.
  ## 
  let valid = call_597300.validator(path, query, header, formData, body)
  let scheme = call_597300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597300.url(scheme.get, call_597300.host, call_597300.base,
                         call_597300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597300, url, valid)

proc call*(call_597301: Call_TagListByProduct_597289; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByProduct
  ## Lists all Tags associated with the Product.
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
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_597302 = newJObject()
  var query_597303 = newJObject()
  add(path_597302, "resourceGroupName", newJString(resourceGroupName))
  add(query_597303, "api-version", newJString(apiVersion))
  add(path_597302, "subscriptionId", newJString(subscriptionId))
  add(query_597303, "$top", newJInt(Top))
  add(query_597303, "$skip", newJInt(Skip))
  add(path_597302, "productId", newJString(productId))
  add(path_597302, "serviceName", newJString(serviceName))
  add(query_597303, "$filter", newJString(Filter))
  result = call_597301.call(path_597302, query_597303, nil, nil, nil)

var tagListByProduct* = Call_TagListByProduct_597289(name: "tagListByProduct",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags",
    validator: validate_TagListByProduct_597290, base: "",
    url: url_TagListByProduct_597291, schemes: {Scheme.Https})
type
  Call_TagAssignToProduct_597317 = ref object of OpenApiRestCall_596457
proc url_TagAssignToProduct_597319(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToProduct_597318(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Assign tag to the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597320 = path.getOrDefault("tagId")
  valid_597320 = validateParameter(valid_597320, JString, required = true,
                                 default = nil)
  if valid_597320 != nil:
    section.add "tagId", valid_597320
  var valid_597321 = path.getOrDefault("resourceGroupName")
  valid_597321 = validateParameter(valid_597321, JString, required = true,
                                 default = nil)
  if valid_597321 != nil:
    section.add "resourceGroupName", valid_597321
  var valid_597322 = path.getOrDefault("subscriptionId")
  valid_597322 = validateParameter(valid_597322, JString, required = true,
                                 default = nil)
  if valid_597322 != nil:
    section.add "subscriptionId", valid_597322
  var valid_597323 = path.getOrDefault("productId")
  valid_597323 = validateParameter(valid_597323, JString, required = true,
                                 default = nil)
  if valid_597323 != nil:
    section.add "productId", valid_597323
  var valid_597324 = path.getOrDefault("serviceName")
  valid_597324 = validateParameter(valid_597324, JString, required = true,
                                 default = nil)
  if valid_597324 != nil:
    section.add "serviceName", valid_597324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597325 = query.getOrDefault("api-version")
  valid_597325 = validateParameter(valid_597325, JString, required = true,
                                 default = nil)
  if valid_597325 != nil:
    section.add "api-version", valid_597325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597326: Call_TagAssignToProduct_597317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Product.
  ## 
  let valid = call_597326.validator(path, query, header, formData, body)
  let scheme = call_597326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597326.url(scheme.get, call_597326.host, call_597326.base,
                         call_597326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597326, url, valid)

proc call*(call_597327: Call_TagAssignToProduct_597317; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagAssignToProduct
  ## Assign tag to the Product.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_597328 = newJObject()
  var query_597329 = newJObject()
  add(path_597328, "tagId", newJString(tagId))
  add(path_597328, "resourceGroupName", newJString(resourceGroupName))
  add(query_597329, "api-version", newJString(apiVersion))
  add(path_597328, "subscriptionId", newJString(subscriptionId))
  add(path_597328, "productId", newJString(productId))
  add(path_597328, "serviceName", newJString(serviceName))
  result = call_597327.call(path_597328, query_597329, nil, nil, nil)

var tagAssignToProduct* = Call_TagAssignToProduct_597317(
    name: "tagAssignToProduct", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagAssignToProduct_597318, base: "",
    url: url_TagAssignToProduct_597319, schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByProduct_597343 = ref object of OpenApiRestCall_596457
proc url_TagGetEntityStateByProduct_597345(protocol: Scheme; host: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByProduct_597344(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597346 = path.getOrDefault("tagId")
  valid_597346 = validateParameter(valid_597346, JString, required = true,
                                 default = nil)
  if valid_597346 != nil:
    section.add "tagId", valid_597346
  var valid_597347 = path.getOrDefault("resourceGroupName")
  valid_597347 = validateParameter(valid_597347, JString, required = true,
                                 default = nil)
  if valid_597347 != nil:
    section.add "resourceGroupName", valid_597347
  var valid_597348 = path.getOrDefault("subscriptionId")
  valid_597348 = validateParameter(valid_597348, JString, required = true,
                                 default = nil)
  if valid_597348 != nil:
    section.add "subscriptionId", valid_597348
  var valid_597349 = path.getOrDefault("productId")
  valid_597349 = validateParameter(valid_597349, JString, required = true,
                                 default = nil)
  if valid_597349 != nil:
    section.add "productId", valid_597349
  var valid_597350 = path.getOrDefault("serviceName")
  valid_597350 = validateParameter(valid_597350, JString, required = true,
                                 default = nil)
  if valid_597350 != nil:
    section.add "serviceName", valid_597350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597351 = query.getOrDefault("api-version")
  valid_597351 = validateParameter(valid_597351, JString, required = true,
                                 default = nil)
  if valid_597351 != nil:
    section.add "api-version", valid_597351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597352: Call_TagGetEntityStateByProduct_597343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_597352.validator(path, query, header, formData, body)
  let scheme = call_597352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597352.url(scheme.get, call_597352.host, call_597352.base,
                         call_597352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597352, url, valid)

proc call*(call_597353: Call_TagGetEntityStateByProduct_597343; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagGetEntityStateByProduct
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_597354 = newJObject()
  var query_597355 = newJObject()
  add(path_597354, "tagId", newJString(tagId))
  add(path_597354, "resourceGroupName", newJString(resourceGroupName))
  add(query_597355, "api-version", newJString(apiVersion))
  add(path_597354, "subscriptionId", newJString(subscriptionId))
  add(path_597354, "productId", newJString(productId))
  add(path_597354, "serviceName", newJString(serviceName))
  result = call_597353.call(path_597354, query_597355, nil, nil, nil)

var tagGetEntityStateByProduct* = Call_TagGetEntityStateByProduct_597343(
    name: "tagGetEntityStateByProduct", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByProduct_597344, base: "",
    url: url_TagGetEntityStateByProduct_597345, schemes: {Scheme.Https})
type
  Call_TagGetByProduct_597304 = ref object of OpenApiRestCall_596457
proc url_TagGetByProduct_597306(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByProduct_597305(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get tag associated with the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597307 = path.getOrDefault("tagId")
  valid_597307 = validateParameter(valid_597307, JString, required = true,
                                 default = nil)
  if valid_597307 != nil:
    section.add "tagId", valid_597307
  var valid_597308 = path.getOrDefault("resourceGroupName")
  valid_597308 = validateParameter(valid_597308, JString, required = true,
                                 default = nil)
  if valid_597308 != nil:
    section.add "resourceGroupName", valid_597308
  var valid_597309 = path.getOrDefault("subscriptionId")
  valid_597309 = validateParameter(valid_597309, JString, required = true,
                                 default = nil)
  if valid_597309 != nil:
    section.add "subscriptionId", valid_597309
  var valid_597310 = path.getOrDefault("productId")
  valid_597310 = validateParameter(valid_597310, JString, required = true,
                                 default = nil)
  if valid_597310 != nil:
    section.add "productId", valid_597310
  var valid_597311 = path.getOrDefault("serviceName")
  valid_597311 = validateParameter(valid_597311, JString, required = true,
                                 default = nil)
  if valid_597311 != nil:
    section.add "serviceName", valid_597311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597312 = query.getOrDefault("api-version")
  valid_597312 = validateParameter(valid_597312, JString, required = true,
                                 default = nil)
  if valid_597312 != nil:
    section.add "api-version", valid_597312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597313: Call_TagGetByProduct_597304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the Product.
  ## 
  let valid = call_597313.validator(path, query, header, formData, body)
  let scheme = call_597313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597313.url(scheme.get, call_597313.host, call_597313.base,
                         call_597313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597313, url, valid)

proc call*(call_597314: Call_TagGetByProduct_597304; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagGetByProduct
  ## Get tag associated with the Product.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_597315 = newJObject()
  var query_597316 = newJObject()
  add(path_597315, "tagId", newJString(tagId))
  add(path_597315, "resourceGroupName", newJString(resourceGroupName))
  add(query_597316, "api-version", newJString(apiVersion))
  add(path_597315, "subscriptionId", newJString(subscriptionId))
  add(path_597315, "productId", newJString(productId))
  add(path_597315, "serviceName", newJString(serviceName))
  result = call_597314.call(path_597315, query_597316, nil, nil, nil)

var tagGetByProduct* = Call_TagGetByProduct_597304(name: "tagGetByProduct",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagGetByProduct_597305, base: "", url: url_TagGetByProduct_597306,
    schemes: {Scheme.Https})
type
  Call_TagDetachFromProduct_597330 = ref object of OpenApiRestCall_596457
proc url_TagDetachFromProduct_597332(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromProduct_597331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the tag from the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597333 = path.getOrDefault("tagId")
  valid_597333 = validateParameter(valid_597333, JString, required = true,
                                 default = nil)
  if valid_597333 != nil:
    section.add "tagId", valid_597333
  var valid_597334 = path.getOrDefault("resourceGroupName")
  valid_597334 = validateParameter(valid_597334, JString, required = true,
                                 default = nil)
  if valid_597334 != nil:
    section.add "resourceGroupName", valid_597334
  var valid_597335 = path.getOrDefault("subscriptionId")
  valid_597335 = validateParameter(valid_597335, JString, required = true,
                                 default = nil)
  if valid_597335 != nil:
    section.add "subscriptionId", valid_597335
  var valid_597336 = path.getOrDefault("productId")
  valid_597336 = validateParameter(valid_597336, JString, required = true,
                                 default = nil)
  if valid_597336 != nil:
    section.add "productId", valid_597336
  var valid_597337 = path.getOrDefault("serviceName")
  valid_597337 = validateParameter(valid_597337, JString, required = true,
                                 default = nil)
  if valid_597337 != nil:
    section.add "serviceName", valid_597337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597338 = query.getOrDefault("api-version")
  valid_597338 = validateParameter(valid_597338, JString, required = true,
                                 default = nil)
  if valid_597338 != nil:
    section.add "api-version", valid_597338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597339: Call_TagDetachFromProduct_597330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Product.
  ## 
  let valid = call_597339.validator(path, query, header, formData, body)
  let scheme = call_597339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597339.url(scheme.get, call_597339.host, call_597339.base,
                         call_597339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597339, url, valid)

proc call*(call_597340: Call_TagDetachFromProduct_597330; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagDetachFromProduct
  ## Detach the tag from the Product.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_597341 = newJObject()
  var query_597342 = newJObject()
  add(path_597341, "tagId", newJString(tagId))
  add(path_597341, "resourceGroupName", newJString(resourceGroupName))
  add(query_597342, "api-version", newJString(apiVersion))
  add(path_597341, "subscriptionId", newJString(subscriptionId))
  add(path_597341, "productId", newJString(productId))
  add(path_597341, "serviceName", newJString(serviceName))
  result = call_597340.call(path_597341, query_597342, nil, nil, nil)

var tagDetachFromProduct* = Call_TagDetachFromProduct_597330(
    name: "tagDetachFromProduct", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagDetachFromProduct_597331, base: "",
    url: url_TagDetachFromProduct_597332, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
