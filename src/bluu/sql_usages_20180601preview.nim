
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure SQL Database management API provides a RESTful set of web APIs that interact with Azure SQL Database services to manage your databases. The API enables users to create, retrieve, update, and delete databases, servers, and other entities.
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "sql-usages"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UsagesListByInstancePool_563778 = ref object of OpenApiRestCall_563556
proc url_UsagesListByInstancePool_563780(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "instancePoolName" in path,
        "`instancePoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/instancePools/"),
               (kind: VariableSegment, value: "instancePoolName"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesListByInstancePool_563779(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all instance pool usage metrics
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   instancePoolName: JString (required)
  ##                   : The name of the instance pool to be retrieved.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("instancePoolName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "instancePoolName", valid_563956
  var valid_563957 = path.getOrDefault("resourceGroupName")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "resourceGroupName", valid_563957
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   expandChildren: JBool
  ##                 : Optional request parameter to include managed instance usages within the instance pool.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563958 = query.getOrDefault("api-version")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "api-version", valid_563958
  var valid_563959 = query.getOrDefault("expandChildren")
  valid_563959 = validateParameter(valid_563959, JBool, required = false, default = nil)
  if valid_563959 != nil:
    section.add "expandChildren", valid_563959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563982: Call_UsagesListByInstancePool_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all instance pool usage metrics
  ## 
  let valid = call_563982.validator(path, query, header, formData, body)
  let scheme = call_563982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563982.url(scheme.get, call_563982.host, call_563982.base,
                         call_563982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563982, url, valid)

proc call*(call_564053: Call_UsagesListByInstancePool_563778; apiVersion: string;
          subscriptionId: string; instancePoolName: string;
          resourceGroupName: string; expandChildren: bool = false): Recallable =
  ## usagesListByInstancePool
  ## Gets all instance pool usage metrics
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   instancePoolName: string (required)
  ##                   : The name of the instance pool to be retrieved.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   expandChildren: bool
  ##                 : Optional request parameter to include managed instance usages within the instance pool.
  var path_564054 = newJObject()
  var query_564056 = newJObject()
  add(query_564056, "api-version", newJString(apiVersion))
  add(path_564054, "subscriptionId", newJString(subscriptionId))
  add(path_564054, "instancePoolName", newJString(instancePoolName))
  add(path_564054, "resourceGroupName", newJString(resourceGroupName))
  add(query_564056, "expandChildren", newJBool(expandChildren))
  result = call_564053.call(path_564054, query_564056, nil, nil, nil)

var usagesListByInstancePool* = Call_UsagesListByInstancePool_563778(
    name: "usagesListByInstancePool", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/instancePools/{instancePoolName}/usages",
    validator: validate_UsagesListByInstancePool_563779, base: "",
    url: url_UsagesListByInstancePool_563780, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
