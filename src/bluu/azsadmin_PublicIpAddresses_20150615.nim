
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkAdminManagementClient
## version: 2015-06-15
## termsOfService: (not provided)
## license: (not provided)
## 
## Public IP Address admin endpoints and objects.
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "azsadmin-PublicIpAddresses"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PublicIPAddressesList_593630 = ref object of OpenApiRestCall_593408
proc url_PublicIPAddressesList_593632(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network.Admin/adminPublicIpAddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of public ip addresses.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593793 = path.getOrDefault("subscriptionId")
  valid_593793 = validateParameter(valid_593793, JString, required = true,
                                 default = nil)
  if valid_593793 != nil:
    section.add "subscriptionId", valid_593793
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $inlineCount: JString
  ##               : OData inline count parameter.
  ##   $top: JString
  ##       : OData top parameter.
  ##   $orderBy: JString
  ##           : OData orderBy parameter.
  ##   $skip: JString
  ##        : OData skip parameter.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  var valid_593808 = query.getOrDefault("$inlineCount")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "$inlineCount", valid_593808
  var valid_593809 = query.getOrDefault("$top")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "$top", valid_593809
  var valid_593810 = query.getOrDefault("$orderBy")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "$orderBy", valid_593810
  var valid_593811 = query.getOrDefault("$skip")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "$skip", valid_593811
  var valid_593812 = query.getOrDefault("$filter")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "$filter", valid_593812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593839: Call_PublicIPAddressesList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of public ip addresses.
  ## 
  let valid = call_593839.validator(path, query, header, formData, body)
  let scheme = call_593839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593839.url(scheme.get, call_593839.host, call_593839.base,
                         call_593839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593839, url, valid)

proc call*(call_593910: Call_PublicIPAddressesList_593630; subscriptionId: string;
          apiVersion: string = "2015-06-15"; InlineCount: string = ""; Top: string = "";
          OrderBy: string = ""; Skip: string = ""; Filter: string = ""): Recallable =
  ## publicIPAddressesList
  ## List of public ip addresses.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   InlineCount: string
  ##              : OData inline count parameter.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: string
  ##      : OData top parameter.
  ##   OrderBy: string
  ##          : OData orderBy parameter.
  ##   Skip: string
  ##       : OData skip parameter.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_593911 = newJObject()
  var query_593913 = newJObject()
  add(query_593913, "api-version", newJString(apiVersion))
  add(query_593913, "$inlineCount", newJString(InlineCount))
  add(path_593911, "subscriptionId", newJString(subscriptionId))
  add(query_593913, "$top", newJString(Top))
  add(query_593913, "$orderBy", newJString(OrderBy))
  add(query_593913, "$skip", newJString(Skip))
  add(query_593913, "$filter", newJString(Filter))
  result = call_593910.call(path_593911, query_593913, nil, nil, nil)

var publicIPAddressesList* = Call_PublicIPAddressesList_593630(
    name: "publicIPAddressesList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network.Admin/adminPublicIpAddresses",
    validator: validate_PublicIPAddressesList_593631, base: "",
    url: url_PublicIPAddressesList_593632, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
