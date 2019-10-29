
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AutomationManagement
## version: 2018-01-15
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "automation-dscNodeCounts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NodeCountInformationGet_563777 = ref object of OpenApiRestCall_563555
proc url_NodeCountInformationGet_563779(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "countType" in path, "`countType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/nodecounts/"),
               (kind: VariableSegment, value: "countType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeCountInformationGet_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve counts for Dsc Nodes.
  ## 
  ## http://aka.ms/azureautomationsdk/nodecounts
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   countType: JString (required)
  ##            : The type of counts to retrieve
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_563954 = path.getOrDefault("automationAccountName")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "automationAccountName", valid_563954
  var valid_563968 = path.getOrDefault("countType")
  valid_563968 = validateParameter(valid_563968, JString, required = true,
                                 default = newJString("status"))
  if valid_563968 != nil:
    section.add "countType", valid_563968
  var valid_563969 = path.getOrDefault("subscriptionId")
  valid_563969 = validateParameter(valid_563969, JString, required = true,
                                 default = nil)
  if valid_563969 != nil:
    section.add "subscriptionId", valid_563969
  var valid_563970 = path.getOrDefault("resourceGroupName")
  valid_563970 = validateParameter(valid_563970, JString, required = true,
                                 default = nil)
  if valid_563970 != nil:
    section.add "resourceGroupName", valid_563970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563971 = query.getOrDefault("api-version")
  valid_563971 = validateParameter(valid_563971, JString, required = true,
                                 default = nil)
  if valid_563971 != nil:
    section.add "api-version", valid_563971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563994: Call_NodeCountInformationGet_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve counts for Dsc Nodes.
  ## 
  ## http://aka.ms/azureautomationsdk/nodecounts
  let valid = call_563994.validator(path, query, header, formData, body)
  let scheme = call_563994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563994.url(scheme.get, call_563994.host, call_563994.base,
                         call_563994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563994, url, valid)

proc call*(call_564065: Call_NodeCountInformationGet_563777; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; countType: string = "status"): Recallable =
  ## nodeCountInformationGet
  ## Retrieve counts for Dsc Nodes.
  ## http://aka.ms/azureautomationsdk/nodecounts
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   countType: string (required)
  ##            : The type of counts to retrieve
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564066 = newJObject()
  var query_564068 = newJObject()
  add(query_564068, "api-version", newJString(apiVersion))
  add(path_564066, "automationAccountName", newJString(automationAccountName))
  add(path_564066, "countType", newJString(countType))
  add(path_564066, "subscriptionId", newJString(subscriptionId))
  add(path_564066, "resourceGroupName", newJString(resourceGroupName))
  result = call_564065.call(path_564066, query_564068, nil, nil, nil)

var nodeCountInformationGet* = Call_NodeCountInformationGet_563777(
    name: "nodeCountInformationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/nodecounts/{countType}",
    validator: validate_NodeCountInformationGet_563778, base: "",
    url: url_NodeCountInformationGet_563779, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
