
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for querying APIs. Operations and Products by tags in your Azure API Management deployment.
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
  macServiceName = "apimanagement-apimtagresources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TagResourceListByService_596680 = ref object of OpenApiRestCall_596458
proc url_TagResourceListByService_596682(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tagResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagResourceListByService_596681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of resources associated with tags.
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
  var valid_596843 = path.getOrDefault("resourceGroupName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "resourceGroupName", valid_596843
  var valid_596844 = path.getOrDefault("subscriptionId")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "subscriptionId", valid_596844
  var valid_596845 = path.getOrDefault("serviceName")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "serviceName", valid_596845
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
  ## | aid         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiName     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | terms       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | isCurrent   | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596846 = query.getOrDefault("api-version")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "api-version", valid_596846
  var valid_596847 = query.getOrDefault("$top")
  valid_596847 = validateParameter(valid_596847, JInt, required = false, default = nil)
  if valid_596847 != nil:
    section.add "$top", valid_596847
  var valid_596848 = query.getOrDefault("$skip")
  valid_596848 = validateParameter(valid_596848, JInt, required = false, default = nil)
  if valid_596848 != nil:
    section.add "$skip", valid_596848
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

proc call*(call_596876: Call_TagResourceListByService_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of resources associated with tags.
  ## 
  let valid = call_596876.validator(path, query, header, formData, body)
  let scheme = call_596876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596876.url(scheme.get, call_596876.host, call_596876.base,
                         call_596876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596876, url, valid)

proc call*(call_596947: Call_TagResourceListByService_596680;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagResourceListByService
  ## Lists a collection of resources associated with tags.
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
  ## | aid         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiName     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | terms       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | isCurrent   | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_596948 = newJObject()
  var query_596950 = newJObject()
  add(path_596948, "resourceGroupName", newJString(resourceGroupName))
  add(query_596950, "api-version", newJString(apiVersion))
  add(path_596948, "subscriptionId", newJString(subscriptionId))
  add(query_596950, "$top", newJInt(Top))
  add(query_596950, "$skip", newJInt(Skip))
  add(path_596948, "serviceName", newJString(serviceName))
  add(query_596950, "$filter", newJString(Filter))
  result = call_596947.call(path_596948, query_596950, nil, nil, nil)

var tagResourceListByService* = Call_TagResourceListByService_596680(
    name: "tagResourceListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tagResources",
    validator: validate_TagResourceListByService_596681, base: "",
    url: url_TagResourceListByService_596682, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
