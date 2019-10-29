
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2015-12-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Storage Management Client.
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-acquisitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AcquisitionsList_563762 = ref object of OpenApiRestCall_563540
proc url_AcquisitionsList_563764(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/acquisitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AcquisitionsList_563763(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a list of BLOB acquisitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `farmId` field"
  var valid_563927 = path.getOrDefault("farmId")
  valid_563927 = validateParameter(valid_563927, JString, required = true,
                                 default = nil)
  if valid_563927 != nil:
    section.add "farmId", valid_563927
  var valid_563928 = path.getOrDefault("subscriptionId")
  valid_563928 = validateParameter(valid_563928, JString, required = true,
                                 default = nil)
  if valid_563928 != nil:
    section.add "subscriptionId", valid_563928
  var valid_563929 = path.getOrDefault("resourceGroupName")
  valid_563929 = validateParameter(valid_563929, JString, required = true,
                                 default = nil)
  if valid_563929 != nil:
    section.add "resourceGroupName", valid_563929
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  ##   $filter: JString
  ##          : Filter string
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563930 = query.getOrDefault("api-version")
  valid_563930 = validateParameter(valid_563930, JString, required = true,
                                 default = nil)
  if valid_563930 != nil:
    section.add "api-version", valid_563930
  var valid_563931 = query.getOrDefault("$filter")
  valid_563931 = validateParameter(valid_563931, JString, required = false,
                                 default = nil)
  if valid_563931 != nil:
    section.add "$filter", valid_563931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563958: Call_AcquisitionsList_563762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of BLOB acquisitions.
  ## 
  let valid = call_563958.validator(path, query, header, formData, body)
  let scheme = call_563958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563958.url(scheme.get, call_563958.host, call_563958.base,
                         call_563958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563958, url, valid)

proc call*(call_564029: Call_AcquisitionsList_563762; apiVersion: string;
          farmId: string; subscriptionId: string; resourceGroupName: string;
          Filter: string = ""): Recallable =
  ## acquisitionsList
  ## Returns a list of BLOB acquisitions.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : Filter string
  var path_564030 = newJObject()
  var query_564032 = newJObject()
  add(query_564032, "api-version", newJString(apiVersion))
  add(path_564030, "farmId", newJString(farmId))
  add(path_564030, "subscriptionId", newJString(subscriptionId))
  add(path_564030, "resourceGroupName", newJString(resourceGroupName))
  add(query_564032, "$filter", newJString(Filter))
  result = call_564029.call(path_564030, query_564032, nil, nil, nil)

var acquisitionsList* = Call_AcquisitionsList_563762(name: "acquisitionsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/acquisitions",
    validator: validate_AcquisitionsList_563763, base: "",
    url: url_AcquisitionsList_563764, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
