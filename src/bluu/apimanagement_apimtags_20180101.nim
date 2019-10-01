
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Tag entity in your Azure API Management deployment. Tags can be assigned to APIs, Operations and Products.
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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimtags"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TagListByOperation_596680 = ref object of OpenApiRestCall_596458
proc url_TagListByOperation_596682(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByOperation_596681(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all Tags associated with the Operation.
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596843 = path.getOrDefault("resourceGroupName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "resourceGroupName", valid_596843
  var valid_596844 = path.getOrDefault("apiId")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "apiId", valid_596844
  var valid_596845 = path.getOrDefault("subscriptionId")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "subscriptionId", valid_596845
  var valid_596846 = path.getOrDefault("serviceName")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "serviceName", valid_596846
  var valid_596847 = path.getOrDefault("operationId")
  valid_596847 = validateParameter(valid_596847, JString, required = true,
                                 default = nil)
  if valid_596847 != nil:
    section.add "operationId", valid_596847
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
  ## | method     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596848 = query.getOrDefault("api-version")
  valid_596848 = validateParameter(valid_596848, JString, required = true,
                                 default = nil)
  if valid_596848 != nil:
    section.add "api-version", valid_596848
  var valid_596849 = query.getOrDefault("$top")
  valid_596849 = validateParameter(valid_596849, JInt, required = false, default = nil)
  if valid_596849 != nil:
    section.add "$top", valid_596849
  var valid_596850 = query.getOrDefault("$skip")
  valid_596850 = validateParameter(valid_596850, JInt, required = false, default = nil)
  if valid_596850 != nil:
    section.add "$skip", valid_596850
  var valid_596851 = query.getOrDefault("$filter")
  valid_596851 = validateParameter(valid_596851, JString, required = false,
                                 default = nil)
  if valid_596851 != nil:
    section.add "$filter", valid_596851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596878: Call_TagListByOperation_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the Operation.
  ## 
  let valid = call_596878.validator(path, query, header, formData, body)
  let scheme = call_596878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596878.url(scheme.get, call_596878.host, call_596878.base,
                         call_596878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596878, url, valid)

proc call*(call_596949: Call_TagListByOperation_596680; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## tagListByOperation
  ## Lists all Tags associated with the Operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_596950 = newJObject()
  var query_596952 = newJObject()
  add(path_596950, "resourceGroupName", newJString(resourceGroupName))
  add(query_596952, "api-version", newJString(apiVersion))
  add(path_596950, "apiId", newJString(apiId))
  add(path_596950, "subscriptionId", newJString(subscriptionId))
  add(query_596952, "$top", newJInt(Top))
  add(query_596952, "$skip", newJInt(Skip))
  add(path_596950, "serviceName", newJString(serviceName))
  add(path_596950, "operationId", newJString(operationId))
  add(query_596952, "$filter", newJString(Filter))
  result = call_596949.call(path_596950, query_596952, nil, nil, nil)

var tagListByOperation* = Call_TagListByOperation_596680(
    name: "tagListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags",
    validator: validate_TagListByOperation_596681, base: "",
    url: url_TagListByOperation_596682, schemes: {Scheme.Https})
type
  Call_TagAssignToOperation_597014 = ref object of OpenApiRestCall_596458
proc url_TagAssignToOperation_597016(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToOperation_597015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign tag to the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597017 = path.getOrDefault("tagId")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = nil)
  if valid_597017 != nil:
    section.add "tagId", valid_597017
  var valid_597018 = path.getOrDefault("resourceGroupName")
  valid_597018 = validateParameter(valid_597018, JString, required = true,
                                 default = nil)
  if valid_597018 != nil:
    section.add "resourceGroupName", valid_597018
  var valid_597019 = path.getOrDefault("apiId")
  valid_597019 = validateParameter(valid_597019, JString, required = true,
                                 default = nil)
  if valid_597019 != nil:
    section.add "apiId", valid_597019
  var valid_597020 = path.getOrDefault("subscriptionId")
  valid_597020 = validateParameter(valid_597020, JString, required = true,
                                 default = nil)
  if valid_597020 != nil:
    section.add "subscriptionId", valid_597020
  var valid_597021 = path.getOrDefault("serviceName")
  valid_597021 = validateParameter(valid_597021, JString, required = true,
                                 default = nil)
  if valid_597021 != nil:
    section.add "serviceName", valid_597021
  var valid_597022 = path.getOrDefault("operationId")
  valid_597022 = validateParameter(valid_597022, JString, required = true,
                                 default = nil)
  if valid_597022 != nil:
    section.add "operationId", valid_597022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597023 = query.getOrDefault("api-version")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "api-version", valid_597023
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597024 = header.getOrDefault("If-Match")
  valid_597024 = validateParameter(valid_597024, JString, required = false,
                                 default = nil)
  if valid_597024 != nil:
    section.add "If-Match", valid_597024
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597025: Call_TagAssignToOperation_597014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Operation.
  ## 
  let valid = call_597025.validator(path, query, header, formData, body)
  let scheme = call_597025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597025.url(scheme.get, call_597025.host, call_597025.base,
                         call_597025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597025, url, valid)

proc call*(call_597026: Call_TagAssignToOperation_597014; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagAssignToOperation
  ## Assign tag to the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597027 = newJObject()
  var query_597028 = newJObject()
  add(path_597027, "tagId", newJString(tagId))
  add(path_597027, "resourceGroupName", newJString(resourceGroupName))
  add(query_597028, "api-version", newJString(apiVersion))
  add(path_597027, "apiId", newJString(apiId))
  add(path_597027, "subscriptionId", newJString(subscriptionId))
  add(path_597027, "serviceName", newJString(serviceName))
  add(path_597027, "operationId", newJString(operationId))
  result = call_597026.call(path_597027, query_597028, nil, nil, nil)

var tagAssignToOperation* = Call_TagAssignToOperation_597014(
    name: "tagAssignToOperation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagAssignToOperation_597015, base: "",
    url: url_TagAssignToOperation_597016, schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByOperation_597044 = ref object of OpenApiRestCall_596458
proc url_TagGetEntityStateByOperation_597046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByOperation_597045(path: JsonNode; query: JsonNode;
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
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597047 = path.getOrDefault("tagId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "tagId", valid_597047
  var valid_597048 = path.getOrDefault("resourceGroupName")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "resourceGroupName", valid_597048
  var valid_597049 = path.getOrDefault("apiId")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "apiId", valid_597049
  var valid_597050 = path.getOrDefault("subscriptionId")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "subscriptionId", valid_597050
  var valid_597051 = path.getOrDefault("serviceName")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "serviceName", valid_597051
  var valid_597052 = path.getOrDefault("operationId")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "operationId", valid_597052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597053 = query.getOrDefault("api-version")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "api-version", valid_597053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597054: Call_TagGetEntityStateByOperation_597044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_597054.validator(path, query, header, formData, body)
  let scheme = call_597054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597054.url(scheme.get, call_597054.host, call_597054.base,
                         call_597054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597054, url, valid)

proc call*(call_597055: Call_TagGetEntityStateByOperation_597044; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagGetEntityStateByOperation
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597056 = newJObject()
  var query_597057 = newJObject()
  add(path_597056, "tagId", newJString(tagId))
  add(path_597056, "resourceGroupName", newJString(resourceGroupName))
  add(query_597057, "api-version", newJString(apiVersion))
  add(path_597056, "apiId", newJString(apiId))
  add(path_597056, "subscriptionId", newJString(subscriptionId))
  add(path_597056, "serviceName", newJString(serviceName))
  add(path_597056, "operationId", newJString(operationId))
  result = call_597055.call(path_597056, query_597057, nil, nil, nil)

var tagGetEntityStateByOperation* = Call_TagGetEntityStateByOperation_597044(
    name: "tagGetEntityStateByOperation", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByOperation_597045, base: "",
    url: url_TagGetEntityStateByOperation_597046, schemes: {Scheme.Https})
type
  Call_TagGetByOperation_596991 = ref object of OpenApiRestCall_596458
proc url_TagGetByOperation_596993(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByOperation_596992(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get tag associated with the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597003 = path.getOrDefault("tagId")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = nil)
  if valid_597003 != nil:
    section.add "tagId", valid_597003
  var valid_597004 = path.getOrDefault("resourceGroupName")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "resourceGroupName", valid_597004
  var valid_597005 = path.getOrDefault("apiId")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "apiId", valid_597005
  var valid_597006 = path.getOrDefault("subscriptionId")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "subscriptionId", valid_597006
  var valid_597007 = path.getOrDefault("serviceName")
  valid_597007 = validateParameter(valid_597007, JString, required = true,
                                 default = nil)
  if valid_597007 != nil:
    section.add "serviceName", valid_597007
  var valid_597008 = path.getOrDefault("operationId")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "operationId", valid_597008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597009 = query.getOrDefault("api-version")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "api-version", valid_597009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597010: Call_TagGetByOperation_596991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the Operation.
  ## 
  let valid = call_597010.validator(path, query, header, formData, body)
  let scheme = call_597010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597010.url(scheme.get, call_597010.host, call_597010.base,
                         call_597010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597010, url, valid)

proc call*(call_597011: Call_TagGetByOperation_596991; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagGetByOperation
  ## Get tag associated with the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597012 = newJObject()
  var query_597013 = newJObject()
  add(path_597012, "tagId", newJString(tagId))
  add(path_597012, "resourceGroupName", newJString(resourceGroupName))
  add(query_597013, "api-version", newJString(apiVersion))
  add(path_597012, "apiId", newJString(apiId))
  add(path_597012, "subscriptionId", newJString(subscriptionId))
  add(path_597012, "serviceName", newJString(serviceName))
  add(path_597012, "operationId", newJString(operationId))
  result = call_597011.call(path_597012, query_597013, nil, nil, nil)

var tagGetByOperation* = Call_TagGetByOperation_596991(name: "tagGetByOperation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagGetByOperation_596992, base: "",
    url: url_TagGetByOperation_596993, schemes: {Scheme.Https})
type
  Call_TagDetachFromOperation_597029 = ref object of OpenApiRestCall_596458
proc url_TagDetachFromOperation_597031(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromOperation_597030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the tag from the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597032 = path.getOrDefault("tagId")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "tagId", valid_597032
  var valid_597033 = path.getOrDefault("resourceGroupName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "resourceGroupName", valid_597033
  var valid_597034 = path.getOrDefault("apiId")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "apiId", valid_597034
  var valid_597035 = path.getOrDefault("subscriptionId")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "subscriptionId", valid_597035
  var valid_597036 = path.getOrDefault("serviceName")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "serviceName", valid_597036
  var valid_597037 = path.getOrDefault("operationId")
  valid_597037 = validateParameter(valid_597037, JString, required = true,
                                 default = nil)
  if valid_597037 != nil:
    section.add "operationId", valid_597037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597038 = query.getOrDefault("api-version")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = nil)
  if valid_597038 != nil:
    section.add "api-version", valid_597038
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597039 = header.getOrDefault("If-Match")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "If-Match", valid_597039
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597040: Call_TagDetachFromOperation_597029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Operation.
  ## 
  let valid = call_597040.validator(path, query, header, formData, body)
  let scheme = call_597040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597040.url(scheme.get, call_597040.host, call_597040.base,
                         call_597040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597040, url, valid)

proc call*(call_597041: Call_TagDetachFromOperation_597029; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagDetachFromOperation
  ## Detach the tag from the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597042 = newJObject()
  var query_597043 = newJObject()
  add(path_597042, "tagId", newJString(tagId))
  add(path_597042, "resourceGroupName", newJString(resourceGroupName))
  add(query_597043, "api-version", newJString(apiVersion))
  add(path_597042, "apiId", newJString(apiId))
  add(path_597042, "subscriptionId", newJString(subscriptionId))
  add(path_597042, "serviceName", newJString(serviceName))
  add(path_597042, "operationId", newJString(operationId))
  result = call_597041.call(path_597042, query_597043, nil, nil, nil)

var tagDetachFromOperation* = Call_TagDetachFromOperation_597029(
    name: "tagDetachFromOperation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagDetachFromOperation_597030, base: "",
    url: url_TagDetachFromOperation_597031, schemes: {Scheme.Https})
type
  Call_OperationListByTags_597058 = ref object of OpenApiRestCall_596458
proc url_OperationListByTags_597060(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operationsByTags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationListByTags_597059(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists a collection of operations associated with tags.
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
  var valid_597062 = path.getOrDefault("apiId")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "apiId", valid_597062
  var valid_597063 = path.getOrDefault("subscriptionId")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "subscriptionId", valid_597063
  var valid_597064 = path.getOrDefault("serviceName")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "serviceName", valid_597064
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
  ## | apiName     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597065 = query.getOrDefault("api-version")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = nil)
  if valid_597065 != nil:
    section.add "api-version", valid_597065
  var valid_597066 = query.getOrDefault("$top")
  valid_597066 = validateParameter(valid_597066, JInt, required = false, default = nil)
  if valid_597066 != nil:
    section.add "$top", valid_597066
  var valid_597067 = query.getOrDefault("$skip")
  valid_597067 = validateParameter(valid_597067, JInt, required = false, default = nil)
  if valid_597067 != nil:
    section.add "$skip", valid_597067
  var valid_597068 = query.getOrDefault("$filter")
  valid_597068 = validateParameter(valid_597068, JString, required = false,
                                 default = nil)
  if valid_597068 != nil:
    section.add "$filter", valid_597068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597069: Call_OperationListByTags_597058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of operations associated with tags.
  ## 
  let valid = call_597069.validator(path, query, header, formData, body)
  let scheme = call_597069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597069.url(scheme.get, call_597069.host, call_597069.base,
                         call_597069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597069, url, valid)

proc call*(call_597070: Call_OperationListByTags_597058; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## operationListByTags
  ## Lists a collection of operations associated with tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiName     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597071 = newJObject()
  var query_597072 = newJObject()
  add(path_597071, "resourceGroupName", newJString(resourceGroupName))
  add(query_597072, "api-version", newJString(apiVersion))
  add(path_597071, "apiId", newJString(apiId))
  add(path_597071, "subscriptionId", newJString(subscriptionId))
  add(query_597072, "$top", newJInt(Top))
  add(query_597072, "$skip", newJInt(Skip))
  add(path_597071, "serviceName", newJString(serviceName))
  add(query_597072, "$filter", newJString(Filter))
  result = call_597070.call(path_597071, query_597072, nil, nil, nil)

var operationListByTags* = Call_OperationListByTags_597058(
    name: "operationListByTags", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operationsByTags",
    validator: validate_OperationListByTags_597059, base: "",
    url: url_OperationListByTags_597060, schemes: {Scheme.Https})
type
  Call_TagDescriptionListByApi_597073 = ref object of OpenApiRestCall_596458
proc url_TagDescriptionListByApi_597075(protocol: Scheme; host: string; base: string;
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
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionListByApi_597074(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597076 = path.getOrDefault("resourceGroupName")
  valid_597076 = validateParameter(valid_597076, JString, required = true,
                                 default = nil)
  if valid_597076 != nil:
    section.add "resourceGroupName", valid_597076
  var valid_597077 = path.getOrDefault("apiId")
  valid_597077 = validateParameter(valid_597077, JString, required = true,
                                 default = nil)
  if valid_597077 != nil:
    section.add "apiId", valid_597077
  var valid_597078 = path.getOrDefault("subscriptionId")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "subscriptionId", valid_597078
  var valid_597079 = path.getOrDefault("serviceName")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = nil)
  if valid_597079 != nil:
    section.add "serviceName", valid_597079
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597080 = query.getOrDefault("api-version")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "api-version", valid_597080
  var valid_597081 = query.getOrDefault("$top")
  valid_597081 = validateParameter(valid_597081, JInt, required = false, default = nil)
  if valid_597081 != nil:
    section.add "$top", valid_597081
  var valid_597082 = query.getOrDefault("$skip")
  valid_597082 = validateParameter(valid_597082, JInt, required = false, default = nil)
  if valid_597082 != nil:
    section.add "$skip", valid_597082
  var valid_597083 = query.getOrDefault("$filter")
  valid_597083 = validateParameter(valid_597083, JString, required = false,
                                 default = nil)
  if valid_597083 != nil:
    section.add "$filter", valid_597083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597084: Call_TagDescriptionListByApi_597073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
  ## 
  let valid = call_597084.validator(path, query, header, formData, body)
  let scheme = call_597084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597084.url(scheme.get, call_597084.host, call_597084.base,
                         call_597084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597084, url, valid)

proc call*(call_597085: Call_TagDescriptionListByApi_597073;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## tagDescriptionListByApi
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597086 = newJObject()
  var query_597087 = newJObject()
  add(path_597086, "resourceGroupName", newJString(resourceGroupName))
  add(query_597087, "api-version", newJString(apiVersion))
  add(path_597086, "apiId", newJString(apiId))
  add(path_597086, "subscriptionId", newJString(subscriptionId))
  add(query_597087, "$top", newJInt(Top))
  add(query_597087, "$skip", newJInt(Skip))
  add(path_597086, "serviceName", newJString(serviceName))
  add(query_597087, "$filter", newJString(Filter))
  result = call_597085.call(path_597086, query_597087, nil, nil, nil)

var tagDescriptionListByApi* = Call_TagDescriptionListByApi_597073(
    name: "tagDescriptionListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions",
    validator: validate_TagDescriptionListByApi_597074, base: "",
    url: url_TagDescriptionListByApi_597075, schemes: {Scheme.Https})
type
  Call_TagDescriptionCreateOrUpdate_597101 = ref object of OpenApiRestCall_596458
proc url_TagDescriptionCreateOrUpdate_597103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionCreateOrUpdate_597102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create/Update tag description in scope of the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597121 = path.getOrDefault("tagId")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = nil)
  if valid_597121 != nil:
    section.add "tagId", valid_597121
  var valid_597122 = path.getOrDefault("resourceGroupName")
  valid_597122 = validateParameter(valid_597122, JString, required = true,
                                 default = nil)
  if valid_597122 != nil:
    section.add "resourceGroupName", valid_597122
  var valid_597123 = path.getOrDefault("apiId")
  valid_597123 = validateParameter(valid_597123, JString, required = true,
                                 default = nil)
  if valid_597123 != nil:
    section.add "apiId", valid_597123
  var valid_597124 = path.getOrDefault("subscriptionId")
  valid_597124 = validateParameter(valid_597124, JString, required = true,
                                 default = nil)
  if valid_597124 != nil:
    section.add "subscriptionId", valid_597124
  var valid_597125 = path.getOrDefault("serviceName")
  valid_597125 = validateParameter(valid_597125, JString, required = true,
                                 default = nil)
  if valid_597125 != nil:
    section.add "serviceName", valid_597125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597126 = query.getOrDefault("api-version")
  valid_597126 = validateParameter(valid_597126, JString, required = true,
                                 default = nil)
  if valid_597126 != nil:
    section.add "api-version", valid_597126
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597127 = header.getOrDefault("If-Match")
  valid_597127 = validateParameter(valid_597127, JString, required = false,
                                 default = nil)
  if valid_597127 != nil:
    section.add "If-Match", valid_597127
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597129: Call_TagDescriptionCreateOrUpdate_597101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/Update tag description in scope of the Api.
  ## 
  let valid = call_597129.validator(path, query, header, formData, body)
  let scheme = call_597129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597129.url(scheme.get, call_597129.host, call_597129.base,
                         call_597129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597129, url, valid)

proc call*(call_597130: Call_TagDescriptionCreateOrUpdate_597101; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## tagDescriptionCreateOrUpdate
  ## Create/Update tag description in scope of the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597131 = newJObject()
  var query_597132 = newJObject()
  var body_597133 = newJObject()
  add(path_597131, "tagId", newJString(tagId))
  add(path_597131, "resourceGroupName", newJString(resourceGroupName))
  add(query_597132, "api-version", newJString(apiVersion))
  add(path_597131, "apiId", newJString(apiId))
  add(path_597131, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597133 = parameters
  add(path_597131, "serviceName", newJString(serviceName))
  result = call_597130.call(path_597131, query_597132, nil, nil, body_597133)

var tagDescriptionCreateOrUpdate* = Call_TagDescriptionCreateOrUpdate_597101(
    name: "tagDescriptionCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionCreateOrUpdate_597102, base: "",
    url: url_TagDescriptionCreateOrUpdate_597103, schemes: {Scheme.Https})
type
  Call_TagDescriptionGetEntityState_597148 = ref object of OpenApiRestCall_596458
proc url_TagDescriptionGetEntityState_597150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionGetEntityState_597149(path: JsonNode; query: JsonNode;
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
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597151 = path.getOrDefault("tagId")
  valid_597151 = validateParameter(valid_597151, JString, required = true,
                                 default = nil)
  if valid_597151 != nil:
    section.add "tagId", valid_597151
  var valid_597152 = path.getOrDefault("resourceGroupName")
  valid_597152 = validateParameter(valid_597152, JString, required = true,
                                 default = nil)
  if valid_597152 != nil:
    section.add "resourceGroupName", valid_597152
  var valid_597153 = path.getOrDefault("apiId")
  valid_597153 = validateParameter(valid_597153, JString, required = true,
                                 default = nil)
  if valid_597153 != nil:
    section.add "apiId", valid_597153
  var valid_597154 = path.getOrDefault("subscriptionId")
  valid_597154 = validateParameter(valid_597154, JString, required = true,
                                 default = nil)
  if valid_597154 != nil:
    section.add "subscriptionId", valid_597154
  var valid_597155 = path.getOrDefault("serviceName")
  valid_597155 = validateParameter(valid_597155, JString, required = true,
                                 default = nil)
  if valid_597155 != nil:
    section.add "serviceName", valid_597155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597156 = query.getOrDefault("api-version")
  valid_597156 = validateParameter(valid_597156, JString, required = true,
                                 default = nil)
  if valid_597156 != nil:
    section.add "api-version", valid_597156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597157: Call_TagDescriptionGetEntityState_597148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_597157.validator(path, query, header, formData, body)
  let scheme = call_597157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597157.url(scheme.get, call_597157.host, call_597157.base,
                         call_597157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597157, url, valid)

proc call*(call_597158: Call_TagDescriptionGetEntityState_597148; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionGetEntityState
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597159 = newJObject()
  var query_597160 = newJObject()
  add(path_597159, "tagId", newJString(tagId))
  add(path_597159, "resourceGroupName", newJString(resourceGroupName))
  add(query_597160, "api-version", newJString(apiVersion))
  add(path_597159, "apiId", newJString(apiId))
  add(path_597159, "subscriptionId", newJString(subscriptionId))
  add(path_597159, "serviceName", newJString(serviceName))
  result = call_597158.call(path_597159, query_597160, nil, nil, nil)

var tagDescriptionGetEntityState* = Call_TagDescriptionGetEntityState_597148(
    name: "tagDescriptionGetEntityState", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionGetEntityState_597149, base: "",
    url: url_TagDescriptionGetEntityState_597150, schemes: {Scheme.Https})
type
  Call_TagDescriptionGet_597088 = ref object of OpenApiRestCall_596458
proc url_TagDescriptionGet_597090(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionGet_597089(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get tag associated with the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597091 = path.getOrDefault("tagId")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "tagId", valid_597091
  var valid_597092 = path.getOrDefault("resourceGroupName")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "resourceGroupName", valid_597092
  var valid_597093 = path.getOrDefault("apiId")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "apiId", valid_597093
  var valid_597094 = path.getOrDefault("subscriptionId")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "subscriptionId", valid_597094
  var valid_597095 = path.getOrDefault("serviceName")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "serviceName", valid_597095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597096 = query.getOrDefault("api-version")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = nil)
  if valid_597096 != nil:
    section.add "api-version", valid_597096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597097: Call_TagDescriptionGet_597088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the API.
  ## 
  let valid = call_597097.validator(path, query, header, formData, body)
  let scheme = call_597097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597097.url(scheme.get, call_597097.host, call_597097.base,
                         call_597097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597097, url, valid)

proc call*(call_597098: Call_TagDescriptionGet_597088; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionGet
  ## Get tag associated with the API.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597099 = newJObject()
  var query_597100 = newJObject()
  add(path_597099, "tagId", newJString(tagId))
  add(path_597099, "resourceGroupName", newJString(resourceGroupName))
  add(query_597100, "api-version", newJString(apiVersion))
  add(path_597099, "apiId", newJString(apiId))
  add(path_597099, "subscriptionId", newJString(subscriptionId))
  add(path_597099, "serviceName", newJString(serviceName))
  result = call_597098.call(path_597099, query_597100, nil, nil, nil)

var tagDescriptionGet* = Call_TagDescriptionGet_597088(name: "tagDescriptionGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionGet_597089, base: "",
    url: url_TagDescriptionGet_597090, schemes: {Scheme.Https})
type
  Call_TagDescriptionDelete_597134 = ref object of OpenApiRestCall_596458
proc url_TagDescriptionDelete_597136(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionDelete_597135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete tag description for the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597137 = path.getOrDefault("tagId")
  valid_597137 = validateParameter(valid_597137, JString, required = true,
                                 default = nil)
  if valid_597137 != nil:
    section.add "tagId", valid_597137
  var valid_597138 = path.getOrDefault("resourceGroupName")
  valid_597138 = validateParameter(valid_597138, JString, required = true,
                                 default = nil)
  if valid_597138 != nil:
    section.add "resourceGroupName", valid_597138
  var valid_597139 = path.getOrDefault("apiId")
  valid_597139 = validateParameter(valid_597139, JString, required = true,
                                 default = nil)
  if valid_597139 != nil:
    section.add "apiId", valid_597139
  var valid_597140 = path.getOrDefault("subscriptionId")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "subscriptionId", valid_597140
  var valid_597141 = path.getOrDefault("serviceName")
  valid_597141 = validateParameter(valid_597141, JString, required = true,
                                 default = nil)
  if valid_597141 != nil:
    section.add "serviceName", valid_597141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597142 = query.getOrDefault("api-version")
  valid_597142 = validateParameter(valid_597142, JString, required = true,
                                 default = nil)
  if valid_597142 != nil:
    section.add "api-version", valid_597142
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597143 = header.getOrDefault("If-Match")
  valid_597143 = validateParameter(valid_597143, JString, required = true,
                                 default = nil)
  if valid_597143 != nil:
    section.add "If-Match", valid_597143
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597144: Call_TagDescriptionDelete_597134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete tag description for the Api.
  ## 
  let valid = call_597144.validator(path, query, header, formData, body)
  let scheme = call_597144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597144.url(scheme.get, call_597144.host, call_597144.base,
                         call_597144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597144, url, valid)

proc call*(call_597145: Call_TagDescriptionDelete_597134; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionDelete
  ## Delete tag description for the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597146 = newJObject()
  var query_597147 = newJObject()
  add(path_597146, "tagId", newJString(tagId))
  add(path_597146, "resourceGroupName", newJString(resourceGroupName))
  add(query_597147, "api-version", newJString(apiVersion))
  add(path_597146, "apiId", newJString(apiId))
  add(path_597146, "subscriptionId", newJString(subscriptionId))
  add(path_597146, "serviceName", newJString(serviceName))
  result = call_597145.call(path_597146, query_597147, nil, nil, nil)

var tagDescriptionDelete* = Call_TagDescriptionDelete_597134(
    name: "tagDescriptionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionDelete_597135, base: "",
    url: url_TagDescriptionDelete_597136, schemes: {Scheme.Https})
type
  Call_TagListByApi_597161 = ref object of OpenApiRestCall_596458
proc url_TagListByApi_597163(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByApi_597162(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Tags associated with the API.
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597164 = path.getOrDefault("resourceGroupName")
  valid_597164 = validateParameter(valid_597164, JString, required = true,
                                 default = nil)
  if valid_597164 != nil:
    section.add "resourceGroupName", valid_597164
  var valid_597165 = path.getOrDefault("apiId")
  valid_597165 = validateParameter(valid_597165, JString, required = true,
                                 default = nil)
  if valid_597165 != nil:
    section.add "apiId", valid_597165
  var valid_597166 = path.getOrDefault("subscriptionId")
  valid_597166 = validateParameter(valid_597166, JString, required = true,
                                 default = nil)
  if valid_597166 != nil:
    section.add "subscriptionId", valid_597166
  var valid_597167 = path.getOrDefault("serviceName")
  valid_597167 = validateParameter(valid_597167, JString, required = true,
                                 default = nil)
  if valid_597167 != nil:
    section.add "serviceName", valid_597167
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597168 = query.getOrDefault("api-version")
  valid_597168 = validateParameter(valid_597168, JString, required = true,
                                 default = nil)
  if valid_597168 != nil:
    section.add "api-version", valid_597168
  var valid_597169 = query.getOrDefault("$top")
  valid_597169 = validateParameter(valid_597169, JInt, required = false, default = nil)
  if valid_597169 != nil:
    section.add "$top", valid_597169
  var valid_597170 = query.getOrDefault("$skip")
  valid_597170 = validateParameter(valid_597170, JInt, required = false, default = nil)
  if valid_597170 != nil:
    section.add "$skip", valid_597170
  var valid_597171 = query.getOrDefault("$filter")
  valid_597171 = validateParameter(valid_597171, JString, required = false,
                                 default = nil)
  if valid_597171 != nil:
    section.add "$filter", valid_597171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597172: Call_TagListByApi_597161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the API.
  ## 
  let valid = call_597172.validator(path, query, header, formData, body)
  let scheme = call_597172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597172.url(scheme.get, call_597172.host, call_597172.base,
                         call_597172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597172, url, valid)

proc call*(call_597173: Call_TagListByApi_597161; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByApi
  ## Lists all Tags associated with the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597174 = newJObject()
  var query_597175 = newJObject()
  add(path_597174, "resourceGroupName", newJString(resourceGroupName))
  add(query_597175, "api-version", newJString(apiVersion))
  add(path_597174, "apiId", newJString(apiId))
  add(path_597174, "subscriptionId", newJString(subscriptionId))
  add(query_597175, "$top", newJInt(Top))
  add(query_597175, "$skip", newJInt(Skip))
  add(path_597174, "serviceName", newJString(serviceName))
  add(query_597175, "$filter", newJString(Filter))
  result = call_597173.call(path_597174, query_597175, nil, nil, nil)

var tagListByApi* = Call_TagListByApi_597161(name: "tagListByApi",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags",
    validator: validate_TagListByApi_597162, base: "", url: url_TagListByApi_597163,
    schemes: {Scheme.Https})
type
  Call_TagAssignToApi_597189 = ref object of OpenApiRestCall_596458
proc url_TagAssignToApi_597191(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToApi_597190(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Assign tag to the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597192 = path.getOrDefault("tagId")
  valid_597192 = validateParameter(valid_597192, JString, required = true,
                                 default = nil)
  if valid_597192 != nil:
    section.add "tagId", valid_597192
  var valid_597193 = path.getOrDefault("resourceGroupName")
  valid_597193 = validateParameter(valid_597193, JString, required = true,
                                 default = nil)
  if valid_597193 != nil:
    section.add "resourceGroupName", valid_597193
  var valid_597194 = path.getOrDefault("apiId")
  valid_597194 = validateParameter(valid_597194, JString, required = true,
                                 default = nil)
  if valid_597194 != nil:
    section.add "apiId", valid_597194
  var valid_597195 = path.getOrDefault("subscriptionId")
  valid_597195 = validateParameter(valid_597195, JString, required = true,
                                 default = nil)
  if valid_597195 != nil:
    section.add "subscriptionId", valid_597195
  var valid_597196 = path.getOrDefault("serviceName")
  valid_597196 = validateParameter(valid_597196, JString, required = true,
                                 default = nil)
  if valid_597196 != nil:
    section.add "serviceName", valid_597196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597197 = query.getOrDefault("api-version")
  valid_597197 = validateParameter(valid_597197, JString, required = true,
                                 default = nil)
  if valid_597197 != nil:
    section.add "api-version", valid_597197
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597198 = header.getOrDefault("If-Match")
  valid_597198 = validateParameter(valid_597198, JString, required = false,
                                 default = nil)
  if valid_597198 != nil:
    section.add "If-Match", valid_597198
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597199: Call_TagAssignToApi_597189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Api.
  ## 
  let valid = call_597199.validator(path, query, header, formData, body)
  let scheme = call_597199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597199.url(scheme.get, call_597199.host, call_597199.base,
                         call_597199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597199, url, valid)

proc call*(call_597200: Call_TagAssignToApi_597189; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagAssignToApi
  ## Assign tag to the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597201 = newJObject()
  var query_597202 = newJObject()
  add(path_597201, "tagId", newJString(tagId))
  add(path_597201, "resourceGroupName", newJString(resourceGroupName))
  add(query_597202, "api-version", newJString(apiVersion))
  add(path_597201, "apiId", newJString(apiId))
  add(path_597201, "subscriptionId", newJString(subscriptionId))
  add(path_597201, "serviceName", newJString(serviceName))
  result = call_597200.call(path_597201, query_597202, nil, nil, nil)

var tagAssignToApi* = Call_TagAssignToApi_597189(name: "tagAssignToApi",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagAssignToApi_597190, base: "", url: url_TagAssignToApi_597191,
    schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByApi_597217 = ref object of OpenApiRestCall_596458
proc url_TagGetEntityStateByApi_597219(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByApi_597218(path: JsonNode; query: JsonNode;
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
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597220 = path.getOrDefault("tagId")
  valid_597220 = validateParameter(valid_597220, JString, required = true,
                                 default = nil)
  if valid_597220 != nil:
    section.add "tagId", valid_597220
  var valid_597221 = path.getOrDefault("resourceGroupName")
  valid_597221 = validateParameter(valid_597221, JString, required = true,
                                 default = nil)
  if valid_597221 != nil:
    section.add "resourceGroupName", valid_597221
  var valid_597222 = path.getOrDefault("apiId")
  valid_597222 = validateParameter(valid_597222, JString, required = true,
                                 default = nil)
  if valid_597222 != nil:
    section.add "apiId", valid_597222
  var valid_597223 = path.getOrDefault("subscriptionId")
  valid_597223 = validateParameter(valid_597223, JString, required = true,
                                 default = nil)
  if valid_597223 != nil:
    section.add "subscriptionId", valid_597223
  var valid_597224 = path.getOrDefault("serviceName")
  valid_597224 = validateParameter(valid_597224, JString, required = true,
                                 default = nil)
  if valid_597224 != nil:
    section.add "serviceName", valid_597224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597225 = query.getOrDefault("api-version")
  valid_597225 = validateParameter(valid_597225, JString, required = true,
                                 default = nil)
  if valid_597225 != nil:
    section.add "api-version", valid_597225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597226: Call_TagGetEntityStateByApi_597217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_597226.validator(path, query, header, formData, body)
  let scheme = call_597226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597226.url(scheme.get, call_597226.host, call_597226.base,
                         call_597226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597226, url, valid)

proc call*(call_597227: Call_TagGetEntityStateByApi_597217; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagGetEntityStateByApi
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597228 = newJObject()
  var query_597229 = newJObject()
  add(path_597228, "tagId", newJString(tagId))
  add(path_597228, "resourceGroupName", newJString(resourceGroupName))
  add(query_597229, "api-version", newJString(apiVersion))
  add(path_597228, "apiId", newJString(apiId))
  add(path_597228, "subscriptionId", newJString(subscriptionId))
  add(path_597228, "serviceName", newJString(serviceName))
  result = call_597227.call(path_597228, query_597229, nil, nil, nil)

var tagGetEntityStateByApi* = Call_TagGetEntityStateByApi_597217(
    name: "tagGetEntityStateByApi", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByApi_597218, base: "",
    url: url_TagGetEntityStateByApi_597219, schemes: {Scheme.Https})
type
  Call_TagGetByApi_597176 = ref object of OpenApiRestCall_596458
proc url_TagGetByApi_597178(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByApi_597177(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get tag associated with the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597179 = path.getOrDefault("tagId")
  valid_597179 = validateParameter(valid_597179, JString, required = true,
                                 default = nil)
  if valid_597179 != nil:
    section.add "tagId", valid_597179
  var valid_597180 = path.getOrDefault("resourceGroupName")
  valid_597180 = validateParameter(valid_597180, JString, required = true,
                                 default = nil)
  if valid_597180 != nil:
    section.add "resourceGroupName", valid_597180
  var valid_597181 = path.getOrDefault("apiId")
  valid_597181 = validateParameter(valid_597181, JString, required = true,
                                 default = nil)
  if valid_597181 != nil:
    section.add "apiId", valid_597181
  var valid_597182 = path.getOrDefault("subscriptionId")
  valid_597182 = validateParameter(valid_597182, JString, required = true,
                                 default = nil)
  if valid_597182 != nil:
    section.add "subscriptionId", valid_597182
  var valid_597183 = path.getOrDefault("serviceName")
  valid_597183 = validateParameter(valid_597183, JString, required = true,
                                 default = nil)
  if valid_597183 != nil:
    section.add "serviceName", valid_597183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597184 = query.getOrDefault("api-version")
  valid_597184 = validateParameter(valid_597184, JString, required = true,
                                 default = nil)
  if valid_597184 != nil:
    section.add "api-version", valid_597184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597185: Call_TagGetByApi_597176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the API.
  ## 
  let valid = call_597185.validator(path, query, header, formData, body)
  let scheme = call_597185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597185.url(scheme.get, call_597185.host, call_597185.base,
                         call_597185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597185, url, valid)

proc call*(call_597186: Call_TagGetByApi_597176; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagGetByApi
  ## Get tag associated with the API.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597187 = newJObject()
  var query_597188 = newJObject()
  add(path_597187, "tagId", newJString(tagId))
  add(path_597187, "resourceGroupName", newJString(resourceGroupName))
  add(query_597188, "api-version", newJString(apiVersion))
  add(path_597187, "apiId", newJString(apiId))
  add(path_597187, "subscriptionId", newJString(subscriptionId))
  add(path_597187, "serviceName", newJString(serviceName))
  result = call_597186.call(path_597187, query_597188, nil, nil, nil)

var tagGetByApi* = Call_TagGetByApi_597176(name: "tagGetByApi",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
                                        validator: validate_TagGetByApi_597177,
                                        base: "", url: url_TagGetByApi_597178,
                                        schemes: {Scheme.Https})
type
  Call_TagDetachFromApi_597203 = ref object of OpenApiRestCall_596458
proc url_TagDetachFromApi_597205(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromApi_597204(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Detach the tag from the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597206 = path.getOrDefault("tagId")
  valid_597206 = validateParameter(valid_597206, JString, required = true,
                                 default = nil)
  if valid_597206 != nil:
    section.add "tagId", valid_597206
  var valid_597207 = path.getOrDefault("resourceGroupName")
  valid_597207 = validateParameter(valid_597207, JString, required = true,
                                 default = nil)
  if valid_597207 != nil:
    section.add "resourceGroupName", valid_597207
  var valid_597208 = path.getOrDefault("apiId")
  valid_597208 = validateParameter(valid_597208, JString, required = true,
                                 default = nil)
  if valid_597208 != nil:
    section.add "apiId", valid_597208
  var valid_597209 = path.getOrDefault("subscriptionId")
  valid_597209 = validateParameter(valid_597209, JString, required = true,
                                 default = nil)
  if valid_597209 != nil:
    section.add "subscriptionId", valid_597209
  var valid_597210 = path.getOrDefault("serviceName")
  valid_597210 = validateParameter(valid_597210, JString, required = true,
                                 default = nil)
  if valid_597210 != nil:
    section.add "serviceName", valid_597210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597211 = query.getOrDefault("api-version")
  valid_597211 = validateParameter(valid_597211, JString, required = true,
                                 default = nil)
  if valid_597211 != nil:
    section.add "api-version", valid_597211
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597212 = header.getOrDefault("If-Match")
  valid_597212 = validateParameter(valid_597212, JString, required = true,
                                 default = nil)
  if valid_597212 != nil:
    section.add "If-Match", valid_597212
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597213: Call_TagDetachFromApi_597203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Api.
  ## 
  let valid = call_597213.validator(path, query, header, formData, body)
  let scheme = call_597213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597213.url(scheme.get, call_597213.host, call_597213.base,
                         call_597213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597213, url, valid)

proc call*(call_597214: Call_TagDetachFromApi_597203; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDetachFromApi
  ## Detach the tag from the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597215 = newJObject()
  var query_597216 = newJObject()
  add(path_597215, "tagId", newJString(tagId))
  add(path_597215, "resourceGroupName", newJString(resourceGroupName))
  add(query_597216, "api-version", newJString(apiVersion))
  add(path_597215, "apiId", newJString(apiId))
  add(path_597215, "subscriptionId", newJString(subscriptionId))
  add(path_597215, "serviceName", newJString(serviceName))
  result = call_597214.call(path_597215, query_597216, nil, nil, nil)

var tagDetachFromApi* = Call_TagDetachFromApi_597203(name: "tagDetachFromApi",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagDetachFromApi_597204, base: "",
    url: url_TagDetachFromApi_597205, schemes: {Scheme.Https})
type
  Call_TagListByProduct_597230 = ref object of OpenApiRestCall_596458
proc url_TagListByProduct_597232(protocol: Scheme; host: string; base: string;
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

proc validate_TagListByProduct_597231(path: JsonNode; query: JsonNode;
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
  var valid_597233 = path.getOrDefault("resourceGroupName")
  valid_597233 = validateParameter(valid_597233, JString, required = true,
                                 default = nil)
  if valid_597233 != nil:
    section.add "resourceGroupName", valid_597233
  var valid_597234 = path.getOrDefault("subscriptionId")
  valid_597234 = validateParameter(valid_597234, JString, required = true,
                                 default = nil)
  if valid_597234 != nil:
    section.add "subscriptionId", valid_597234
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597237 = query.getOrDefault("api-version")
  valid_597237 = validateParameter(valid_597237, JString, required = true,
                                 default = nil)
  if valid_597237 != nil:
    section.add "api-version", valid_597237
  var valid_597238 = query.getOrDefault("$top")
  valid_597238 = validateParameter(valid_597238, JInt, required = false, default = nil)
  if valid_597238 != nil:
    section.add "$top", valid_597238
  var valid_597239 = query.getOrDefault("$skip")
  valid_597239 = validateParameter(valid_597239, JInt, required = false, default = nil)
  if valid_597239 != nil:
    section.add "$skip", valid_597239
  var valid_597240 = query.getOrDefault("$filter")
  valid_597240 = validateParameter(valid_597240, JString, required = false,
                                 default = nil)
  if valid_597240 != nil:
    section.add "$filter", valid_597240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597241: Call_TagListByProduct_597230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the Product.
  ## 
  let valid = call_597241.validator(path, query, header, formData, body)
  let scheme = call_597241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597241.url(scheme.get, call_597241.host, call_597241.base,
                         call_597241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597241, url, valid)

proc call*(call_597242: Call_TagListByProduct_597230; resourceGroupName: string;
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
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597243 = newJObject()
  var query_597244 = newJObject()
  add(path_597243, "resourceGroupName", newJString(resourceGroupName))
  add(query_597244, "api-version", newJString(apiVersion))
  add(path_597243, "subscriptionId", newJString(subscriptionId))
  add(query_597244, "$top", newJInt(Top))
  add(query_597244, "$skip", newJInt(Skip))
  add(path_597243, "productId", newJString(productId))
  add(path_597243, "serviceName", newJString(serviceName))
  add(query_597244, "$filter", newJString(Filter))
  result = call_597242.call(path_597243, query_597244, nil, nil, nil)

var tagListByProduct* = Call_TagListByProduct_597230(name: "tagListByProduct",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags",
    validator: validate_TagListByProduct_597231, base: "",
    url: url_TagListByProduct_597232, schemes: {Scheme.Https})
type
  Call_TagAssignToProduct_597258 = ref object of OpenApiRestCall_596458
proc url_TagAssignToProduct_597260(protocol: Scheme; host: string; base: string;
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

proc validate_TagAssignToProduct_597259(path: JsonNode; query: JsonNode;
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
  var valid_597261 = path.getOrDefault("tagId")
  valid_597261 = validateParameter(valid_597261, JString, required = true,
                                 default = nil)
  if valid_597261 != nil:
    section.add "tagId", valid_597261
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
  var valid_597264 = path.getOrDefault("productId")
  valid_597264 = validateParameter(valid_597264, JString, required = true,
                                 default = nil)
  if valid_597264 != nil:
    section.add "productId", valid_597264
  var valid_597265 = path.getOrDefault("serviceName")
  valid_597265 = validateParameter(valid_597265, JString, required = true,
                                 default = nil)
  if valid_597265 != nil:
    section.add "serviceName", valid_597265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597266 = query.getOrDefault("api-version")
  valid_597266 = validateParameter(valid_597266, JString, required = true,
                                 default = nil)
  if valid_597266 != nil:
    section.add "api-version", valid_597266
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597267 = header.getOrDefault("If-Match")
  valid_597267 = validateParameter(valid_597267, JString, required = false,
                                 default = nil)
  if valid_597267 != nil:
    section.add "If-Match", valid_597267
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597268: Call_TagAssignToProduct_597258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Product.
  ## 
  let valid = call_597268.validator(path, query, header, formData, body)
  let scheme = call_597268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597268.url(scheme.get, call_597268.host, call_597268.base,
                         call_597268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597268, url, valid)

proc call*(call_597269: Call_TagAssignToProduct_597258; tagId: string;
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
  var path_597270 = newJObject()
  var query_597271 = newJObject()
  add(path_597270, "tagId", newJString(tagId))
  add(path_597270, "resourceGroupName", newJString(resourceGroupName))
  add(query_597271, "api-version", newJString(apiVersion))
  add(path_597270, "subscriptionId", newJString(subscriptionId))
  add(path_597270, "productId", newJString(productId))
  add(path_597270, "serviceName", newJString(serviceName))
  result = call_597269.call(path_597270, query_597271, nil, nil, nil)

var tagAssignToProduct* = Call_TagAssignToProduct_597258(
    name: "tagAssignToProduct", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagAssignToProduct_597259, base: "",
    url: url_TagAssignToProduct_597260, schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByProduct_597286 = ref object of OpenApiRestCall_596458
proc url_TagGetEntityStateByProduct_597288(protocol: Scheme; host: string;
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

proc validate_TagGetEntityStateByProduct_597287(path: JsonNode; query: JsonNode;
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
  var valid_597289 = path.getOrDefault("tagId")
  valid_597289 = validateParameter(valid_597289, JString, required = true,
                                 default = nil)
  if valid_597289 != nil:
    section.add "tagId", valid_597289
  var valid_597290 = path.getOrDefault("resourceGroupName")
  valid_597290 = validateParameter(valid_597290, JString, required = true,
                                 default = nil)
  if valid_597290 != nil:
    section.add "resourceGroupName", valid_597290
  var valid_597291 = path.getOrDefault("subscriptionId")
  valid_597291 = validateParameter(valid_597291, JString, required = true,
                                 default = nil)
  if valid_597291 != nil:
    section.add "subscriptionId", valid_597291
  var valid_597292 = path.getOrDefault("productId")
  valid_597292 = validateParameter(valid_597292, JString, required = true,
                                 default = nil)
  if valid_597292 != nil:
    section.add "productId", valid_597292
  var valid_597293 = path.getOrDefault("serviceName")
  valid_597293 = validateParameter(valid_597293, JString, required = true,
                                 default = nil)
  if valid_597293 != nil:
    section.add "serviceName", valid_597293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597294 = query.getOrDefault("api-version")
  valid_597294 = validateParameter(valid_597294, JString, required = true,
                                 default = nil)
  if valid_597294 != nil:
    section.add "api-version", valid_597294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597295: Call_TagGetEntityStateByProduct_597286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_597295.validator(path, query, header, formData, body)
  let scheme = call_597295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597295.url(scheme.get, call_597295.host, call_597295.base,
                         call_597295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597295, url, valid)

proc call*(call_597296: Call_TagGetEntityStateByProduct_597286; tagId: string;
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
  var path_597297 = newJObject()
  var query_597298 = newJObject()
  add(path_597297, "tagId", newJString(tagId))
  add(path_597297, "resourceGroupName", newJString(resourceGroupName))
  add(query_597298, "api-version", newJString(apiVersion))
  add(path_597297, "subscriptionId", newJString(subscriptionId))
  add(path_597297, "productId", newJString(productId))
  add(path_597297, "serviceName", newJString(serviceName))
  result = call_597296.call(path_597297, query_597298, nil, nil, nil)

var tagGetEntityStateByProduct* = Call_TagGetEntityStateByProduct_597286(
    name: "tagGetEntityStateByProduct", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByProduct_597287, base: "",
    url: url_TagGetEntityStateByProduct_597288, schemes: {Scheme.Https})
type
  Call_TagGetByProduct_597245 = ref object of OpenApiRestCall_596458
proc url_TagGetByProduct_597247(protocol: Scheme; host: string; base: string;
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

proc validate_TagGetByProduct_597246(path: JsonNode; query: JsonNode;
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
  var valid_597248 = path.getOrDefault("tagId")
  valid_597248 = validateParameter(valid_597248, JString, required = true,
                                 default = nil)
  if valid_597248 != nil:
    section.add "tagId", valid_597248
  var valid_597249 = path.getOrDefault("resourceGroupName")
  valid_597249 = validateParameter(valid_597249, JString, required = true,
                                 default = nil)
  if valid_597249 != nil:
    section.add "resourceGroupName", valid_597249
  var valid_597250 = path.getOrDefault("subscriptionId")
  valid_597250 = validateParameter(valid_597250, JString, required = true,
                                 default = nil)
  if valid_597250 != nil:
    section.add "subscriptionId", valid_597250
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597254: Call_TagGetByProduct_597245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the Product.
  ## 
  let valid = call_597254.validator(path, query, header, formData, body)
  let scheme = call_597254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597254.url(scheme.get, call_597254.host, call_597254.base,
                         call_597254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597254, url, valid)

proc call*(call_597255: Call_TagGetByProduct_597245; tagId: string;
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
  var path_597256 = newJObject()
  var query_597257 = newJObject()
  add(path_597256, "tagId", newJString(tagId))
  add(path_597256, "resourceGroupName", newJString(resourceGroupName))
  add(query_597257, "api-version", newJString(apiVersion))
  add(path_597256, "subscriptionId", newJString(subscriptionId))
  add(path_597256, "productId", newJString(productId))
  add(path_597256, "serviceName", newJString(serviceName))
  result = call_597255.call(path_597256, query_597257, nil, nil, nil)

var tagGetByProduct* = Call_TagGetByProduct_597245(name: "tagGetByProduct",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagGetByProduct_597246, base: "", url: url_TagGetByProduct_597247,
    schemes: {Scheme.Https})
type
  Call_TagDetachFromProduct_597272 = ref object of OpenApiRestCall_596458
proc url_TagDetachFromProduct_597274(protocol: Scheme; host: string; base: string;
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

proc validate_TagDetachFromProduct_597273(path: JsonNode; query: JsonNode;
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
  var valid_597275 = path.getOrDefault("tagId")
  valid_597275 = validateParameter(valid_597275, JString, required = true,
                                 default = nil)
  if valid_597275 != nil:
    section.add "tagId", valid_597275
  var valid_597276 = path.getOrDefault("resourceGroupName")
  valid_597276 = validateParameter(valid_597276, JString, required = true,
                                 default = nil)
  if valid_597276 != nil:
    section.add "resourceGroupName", valid_597276
  var valid_597277 = path.getOrDefault("subscriptionId")
  valid_597277 = validateParameter(valid_597277, JString, required = true,
                                 default = nil)
  if valid_597277 != nil:
    section.add "subscriptionId", valid_597277
  var valid_597278 = path.getOrDefault("productId")
  valid_597278 = validateParameter(valid_597278, JString, required = true,
                                 default = nil)
  if valid_597278 != nil:
    section.add "productId", valid_597278
  var valid_597279 = path.getOrDefault("serviceName")
  valid_597279 = validateParameter(valid_597279, JString, required = true,
                                 default = nil)
  if valid_597279 != nil:
    section.add "serviceName", valid_597279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597280 = query.getOrDefault("api-version")
  valid_597280 = validateParameter(valid_597280, JString, required = true,
                                 default = nil)
  if valid_597280 != nil:
    section.add "api-version", valid_597280
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597281 = header.getOrDefault("If-Match")
  valid_597281 = validateParameter(valid_597281, JString, required = true,
                                 default = nil)
  if valid_597281 != nil:
    section.add "If-Match", valid_597281
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597282: Call_TagDetachFromProduct_597272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Product.
  ## 
  let valid = call_597282.validator(path, query, header, formData, body)
  let scheme = call_597282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597282.url(scheme.get, call_597282.host, call_597282.base,
                         call_597282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597282, url, valid)

proc call*(call_597283: Call_TagDetachFromProduct_597272; tagId: string;
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
  var path_597284 = newJObject()
  var query_597285 = newJObject()
  add(path_597284, "tagId", newJString(tagId))
  add(path_597284, "resourceGroupName", newJString(resourceGroupName))
  add(query_597285, "api-version", newJString(apiVersion))
  add(path_597284, "subscriptionId", newJString(subscriptionId))
  add(path_597284, "productId", newJString(productId))
  add(path_597284, "serviceName", newJString(serviceName))
  result = call_597283.call(path_597284, query_597285, nil, nil, nil)

var tagDetachFromProduct* = Call_TagDetachFromProduct_597272(
    name: "tagDetachFromProduct", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagDetachFromProduct_597273, base: "",
    url: url_TagDetachFromProduct_597274, schemes: {Scheme.Https})
type
  Call_TagListByService_597299 = ref object of OpenApiRestCall_596458
proc url_TagListByService_597301(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByService_597300(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists a collection of tags defined within a service instance.
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
  var valid_597302 = path.getOrDefault("resourceGroupName")
  valid_597302 = validateParameter(valid_597302, JString, required = true,
                                 default = nil)
  if valid_597302 != nil:
    section.add "resourceGroupName", valid_597302
  var valid_597303 = path.getOrDefault("subscriptionId")
  valid_597303 = validateParameter(valid_597303, JString, required = true,
                                 default = nil)
  if valid_597303 != nil:
    section.add "subscriptionId", valid_597303
  var valid_597304 = path.getOrDefault("serviceName")
  valid_597304 = validateParameter(valid_597304, JString, required = true,
                                 default = nil)
  if valid_597304 != nil:
    section.add "serviceName", valid_597304
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597305 = query.getOrDefault("api-version")
  valid_597305 = validateParameter(valid_597305, JString, required = true,
                                 default = nil)
  if valid_597305 != nil:
    section.add "api-version", valid_597305
  var valid_597306 = query.getOrDefault("$top")
  valid_597306 = validateParameter(valid_597306, JInt, required = false, default = nil)
  if valid_597306 != nil:
    section.add "$top", valid_597306
  var valid_597307 = query.getOrDefault("$skip")
  valid_597307 = validateParameter(valid_597307, JInt, required = false, default = nil)
  if valid_597307 != nil:
    section.add "$skip", valid_597307
  var valid_597308 = query.getOrDefault("$filter")
  valid_597308 = validateParameter(valid_597308, JString, required = false,
                                 default = nil)
  if valid_597308 != nil:
    section.add "$filter", valid_597308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597309: Call_TagListByService_597299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of tags defined within a service instance.
  ## 
  let valid = call_597309.validator(path, query, header, formData, body)
  let scheme = call_597309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597309.url(scheme.get, call_597309.host, call_597309.base,
                         call_597309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597309, url, valid)

proc call*(call_597310: Call_TagListByService_597299; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByService
  ## Lists a collection of tags defined within a service instance.
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
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597311 = newJObject()
  var query_597312 = newJObject()
  add(path_597311, "resourceGroupName", newJString(resourceGroupName))
  add(query_597312, "api-version", newJString(apiVersion))
  add(path_597311, "subscriptionId", newJString(subscriptionId))
  add(query_597312, "$top", newJInt(Top))
  add(query_597312, "$skip", newJInt(Skip))
  add(path_597311, "serviceName", newJString(serviceName))
  add(query_597312, "$filter", newJString(Filter))
  result = call_597310.call(path_597311, query_597312, nil, nil, nil)

var tagListByService* = Call_TagListByService_597299(name: "tagListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags",
    validator: validate_TagListByService_597300, base: "",
    url: url_TagListByService_597301, schemes: {Scheme.Https})
type
  Call_TagCreateOrUpdate_597325 = ref object of OpenApiRestCall_596458
proc url_TagCreateOrUpdate_597327(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagCreateOrUpdate_597326(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a tag.
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597328 = path.getOrDefault("tagId")
  valid_597328 = validateParameter(valid_597328, JString, required = true,
                                 default = nil)
  if valid_597328 != nil:
    section.add "tagId", valid_597328
  var valid_597329 = path.getOrDefault("resourceGroupName")
  valid_597329 = validateParameter(valid_597329, JString, required = true,
                                 default = nil)
  if valid_597329 != nil:
    section.add "resourceGroupName", valid_597329
  var valid_597330 = path.getOrDefault("subscriptionId")
  valid_597330 = validateParameter(valid_597330, JString, required = true,
                                 default = nil)
  if valid_597330 != nil:
    section.add "subscriptionId", valid_597330
  var valid_597331 = path.getOrDefault("serviceName")
  valid_597331 = validateParameter(valid_597331, JString, required = true,
                                 default = nil)
  if valid_597331 != nil:
    section.add "serviceName", valid_597331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597332 = query.getOrDefault("api-version")
  valid_597332 = validateParameter(valid_597332, JString, required = true,
                                 default = nil)
  if valid_597332 != nil:
    section.add "api-version", valid_597332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597334: Call_TagCreateOrUpdate_597325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag.
  ## 
  let valid = call_597334.validator(path, query, header, formData, body)
  let scheme = call_597334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597334.url(scheme.get, call_597334.host, call_597334.base,
                         call_597334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597334, url, valid)

proc call*(call_597335: Call_TagCreateOrUpdate_597325; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tagCreateOrUpdate
  ## Creates a tag.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597336 = newJObject()
  var query_597337 = newJObject()
  var body_597338 = newJObject()
  add(path_597336, "tagId", newJString(tagId))
  add(path_597336, "resourceGroupName", newJString(resourceGroupName))
  add(query_597337, "api-version", newJString(apiVersion))
  add(path_597336, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597338 = parameters
  add(path_597336, "serviceName", newJString(serviceName))
  result = call_597335.call(path_597336, query_597337, nil, nil, body_597338)

var tagCreateOrUpdate* = Call_TagCreateOrUpdate_597325(name: "tagCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
    validator: validate_TagCreateOrUpdate_597326, base: "",
    url: url_TagCreateOrUpdate_597327, schemes: {Scheme.Https})
type
  Call_TagGetEntityState_597352 = ref object of OpenApiRestCall_596458
proc url_TagGetEntityState_597354(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityState_597353(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597355 = path.getOrDefault("tagId")
  valid_597355 = validateParameter(valid_597355, JString, required = true,
                                 default = nil)
  if valid_597355 != nil:
    section.add "tagId", valid_597355
  var valid_597356 = path.getOrDefault("resourceGroupName")
  valid_597356 = validateParameter(valid_597356, JString, required = true,
                                 default = nil)
  if valid_597356 != nil:
    section.add "resourceGroupName", valid_597356
  var valid_597357 = path.getOrDefault("subscriptionId")
  valid_597357 = validateParameter(valid_597357, JString, required = true,
                                 default = nil)
  if valid_597357 != nil:
    section.add "subscriptionId", valid_597357
  var valid_597358 = path.getOrDefault("serviceName")
  valid_597358 = validateParameter(valid_597358, JString, required = true,
                                 default = nil)
  if valid_597358 != nil:
    section.add "serviceName", valid_597358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597359 = query.getOrDefault("api-version")
  valid_597359 = validateParameter(valid_597359, JString, required = true,
                                 default = nil)
  if valid_597359 != nil:
    section.add "api-version", valid_597359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597360: Call_TagGetEntityState_597352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_597360.validator(path, query, header, formData, body)
  let scheme = call_597360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597360.url(scheme.get, call_597360.host, call_597360.base,
                         call_597360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597360, url, valid)

proc call*(call_597361: Call_TagGetEntityState_597352; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tagGetEntityState
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597362 = newJObject()
  var query_597363 = newJObject()
  add(path_597362, "tagId", newJString(tagId))
  add(path_597362, "resourceGroupName", newJString(resourceGroupName))
  add(query_597363, "api-version", newJString(apiVersion))
  add(path_597362, "subscriptionId", newJString(subscriptionId))
  add(path_597362, "serviceName", newJString(serviceName))
  result = call_597361.call(path_597362, query_597363, nil, nil, nil)

var tagGetEntityState* = Call_TagGetEntityState_597352(name: "tagGetEntityState",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
    validator: validate_TagGetEntityState_597353, base: "",
    url: url_TagGetEntityState_597354, schemes: {Scheme.Https})
type
  Call_TagGet_597313 = ref object of OpenApiRestCall_596458
proc url_TagGet_597315(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGet_597314(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the tag specified by its identifier.
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597316 = path.getOrDefault("tagId")
  valid_597316 = validateParameter(valid_597316, JString, required = true,
                                 default = nil)
  if valid_597316 != nil:
    section.add "tagId", valid_597316
  var valid_597317 = path.getOrDefault("resourceGroupName")
  valid_597317 = validateParameter(valid_597317, JString, required = true,
                                 default = nil)
  if valid_597317 != nil:
    section.add "resourceGroupName", valid_597317
  var valid_597318 = path.getOrDefault("subscriptionId")
  valid_597318 = validateParameter(valid_597318, JString, required = true,
                                 default = nil)
  if valid_597318 != nil:
    section.add "subscriptionId", valid_597318
  var valid_597319 = path.getOrDefault("serviceName")
  valid_597319 = validateParameter(valid_597319, JString, required = true,
                                 default = nil)
  if valid_597319 != nil:
    section.add "serviceName", valid_597319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597320 = query.getOrDefault("api-version")
  valid_597320 = validateParameter(valid_597320, JString, required = true,
                                 default = nil)
  if valid_597320 != nil:
    section.add "api-version", valid_597320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597321: Call_TagGet_597313; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the tag specified by its identifier.
  ## 
  let valid = call_597321.validator(path, query, header, formData, body)
  let scheme = call_597321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597321.url(scheme.get, call_597321.host, call_597321.base,
                         call_597321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597321, url, valid)

proc call*(call_597322: Call_TagGet_597313; tagId: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tagGet
  ## Gets the details of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597323 = newJObject()
  var query_597324 = newJObject()
  add(path_597323, "tagId", newJString(tagId))
  add(path_597323, "resourceGroupName", newJString(resourceGroupName))
  add(query_597324, "api-version", newJString(apiVersion))
  add(path_597323, "subscriptionId", newJString(subscriptionId))
  add(path_597323, "serviceName", newJString(serviceName))
  result = call_597322.call(path_597323, query_597324, nil, nil, nil)

var tagGet* = Call_TagGet_597313(name: "tagGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                              validator: validate_TagGet_597314, base: "",
                              url: url_TagGet_597315, schemes: {Scheme.Https})
type
  Call_TagUpdate_597364 = ref object of OpenApiRestCall_596458
proc url_TagUpdate_597366(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagUpdate_597365(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the tag specified by its identifier.
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597367 = path.getOrDefault("tagId")
  valid_597367 = validateParameter(valid_597367, JString, required = true,
                                 default = nil)
  if valid_597367 != nil:
    section.add "tagId", valid_597367
  var valid_597368 = path.getOrDefault("resourceGroupName")
  valid_597368 = validateParameter(valid_597368, JString, required = true,
                                 default = nil)
  if valid_597368 != nil:
    section.add "resourceGroupName", valid_597368
  var valid_597369 = path.getOrDefault("subscriptionId")
  valid_597369 = validateParameter(valid_597369, JString, required = true,
                                 default = nil)
  if valid_597369 != nil:
    section.add "subscriptionId", valid_597369
  var valid_597370 = path.getOrDefault("serviceName")
  valid_597370 = validateParameter(valid_597370, JString, required = true,
                                 default = nil)
  if valid_597370 != nil:
    section.add "serviceName", valid_597370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597371 = query.getOrDefault("api-version")
  valid_597371 = validateParameter(valid_597371, JString, required = true,
                                 default = nil)
  if valid_597371 != nil:
    section.add "api-version", valid_597371
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597372 = header.getOrDefault("If-Match")
  valid_597372 = validateParameter(valid_597372, JString, required = true,
                                 default = nil)
  if valid_597372 != nil:
    section.add "If-Match", valid_597372
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

proc call*(call_597374: Call_TagUpdate_597364; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the tag specified by its identifier.
  ## 
  let valid = call_597374.validator(path, query, header, formData, body)
  let scheme = call_597374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597374.url(scheme.get, call_597374.host, call_597374.base,
                         call_597374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597374, url, valid)

proc call*(call_597375: Call_TagUpdate_597364; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tagUpdate
  ## Updates the details of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597376 = newJObject()
  var query_597377 = newJObject()
  var body_597378 = newJObject()
  add(path_597376, "tagId", newJString(tagId))
  add(path_597376, "resourceGroupName", newJString(resourceGroupName))
  add(query_597377, "api-version", newJString(apiVersion))
  add(path_597376, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597378 = parameters
  add(path_597376, "serviceName", newJString(serviceName))
  result = call_597375.call(path_597376, query_597377, nil, nil, body_597378)

var tagUpdate* = Call_TagUpdate_597364(name: "tagUpdate", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                                    validator: validate_TagUpdate_597365,
                                    base: "", url: url_TagUpdate_597366,
                                    schemes: {Scheme.Https})
type
  Call_TagDelete_597339 = ref object of OpenApiRestCall_596458
proc url_TagDelete_597341(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDelete_597340(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific tag of the API Management service instance.
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597342 = path.getOrDefault("tagId")
  valid_597342 = validateParameter(valid_597342, JString, required = true,
                                 default = nil)
  if valid_597342 != nil:
    section.add "tagId", valid_597342
  var valid_597343 = path.getOrDefault("resourceGroupName")
  valid_597343 = validateParameter(valid_597343, JString, required = true,
                                 default = nil)
  if valid_597343 != nil:
    section.add "resourceGroupName", valid_597343
  var valid_597344 = path.getOrDefault("subscriptionId")
  valid_597344 = validateParameter(valid_597344, JString, required = true,
                                 default = nil)
  if valid_597344 != nil:
    section.add "subscriptionId", valid_597344
  var valid_597345 = path.getOrDefault("serviceName")
  valid_597345 = validateParameter(valid_597345, JString, required = true,
                                 default = nil)
  if valid_597345 != nil:
    section.add "serviceName", valid_597345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597346 = query.getOrDefault("api-version")
  valid_597346 = validateParameter(valid_597346, JString, required = true,
                                 default = nil)
  if valid_597346 != nil:
    section.add "api-version", valid_597346
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597347 = header.getOrDefault("If-Match")
  valid_597347 = validateParameter(valid_597347, JString, required = true,
                                 default = nil)
  if valid_597347 != nil:
    section.add "If-Match", valid_597347
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597348: Call_TagDelete_597339; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific tag of the API Management service instance.
  ## 
  let valid = call_597348.validator(path, query, header, formData, body)
  let scheme = call_597348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597348.url(scheme.get, call_597348.host, call_597348.base,
                         call_597348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597348, url, valid)

proc call*(call_597349: Call_TagDelete_597339; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tagDelete
  ## Deletes specific tag of the API Management service instance.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597350 = newJObject()
  var query_597351 = newJObject()
  add(path_597350, "tagId", newJString(tagId))
  add(path_597350, "resourceGroupName", newJString(resourceGroupName))
  add(query_597351, "api-version", newJString(apiVersion))
  add(path_597350, "subscriptionId", newJString(subscriptionId))
  add(path_597350, "serviceName", newJString(serviceName))
  result = call_597349.call(path_597350, query_597351, nil, nil, nil)

var tagDelete* = Call_TagDelete_597339(name: "tagDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                                    validator: validate_TagDelete_597340,
                                    base: "", url: url_TagDelete_597341,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
