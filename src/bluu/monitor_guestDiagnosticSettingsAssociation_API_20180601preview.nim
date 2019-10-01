
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Guest Diagnostic Settings Association
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API to Add/Remove/List Guest Diagnostics Settings Association for Azure Resources
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-guestDiagnosticSettingsAssociation_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GuestDiagnosticsSettingsAssociationList_567864 = ref object of OpenApiRestCall_567642
proc url_GuestDiagnosticsSettingsAssociationList_567866(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationList_567865(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all guest diagnostic settings association in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568039 = path.getOrDefault("subscriptionId")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "subscriptionId", valid_568039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_GuestDiagnosticsSettingsAssociationList_567864;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all guest diagnostic settings association in a subscription.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_GuestDiagnosticsSettingsAssociationList_567864;
          apiVersion: string; subscriptionId: string): Recallable =
  ## guestDiagnosticsSettingsAssociationList
  ## Get a list of all guest diagnostic settings association in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_568135 = newJObject()
  var query_568137 = newJObject()
  add(query_568137, "api-version", newJString(apiVersion))
  add(path_568135, "subscriptionId", newJString(subscriptionId))
  result = call_568134.call(path_568135, query_568137, nil, nil, nil)

var guestDiagnosticsSettingsAssociationList* = Call_GuestDiagnosticsSettingsAssociationList_567864(
    name: "guestDiagnosticsSettingsAssociationList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/guestDiagnosticSettingsAssociations",
    validator: validate_GuestDiagnosticsSettingsAssociationList_567865, base: "",
    url: url_GuestDiagnosticsSettingsAssociationList_567866,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_568176 = ref object of OpenApiRestCall_567642
proc url_GuestDiagnosticsSettingsAssociationListByResourceGroup_568178(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationListByResourceGroup_568177(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a list of all guest diagnostic settings association in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568179 = path.getOrDefault("resourceGroupName")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "resourceGroupName", valid_568179
  var valid_568180 = path.getOrDefault("subscriptionId")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "subscriptionId", valid_568180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568181 = query.getOrDefault("api-version")
  valid_568181 = validateParameter(valid_568181, JString, required = true,
                                 default = nil)
  if valid_568181 != nil:
    section.add "api-version", valid_568181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568182: Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all guest diagnostic settings association in a resource group.
  ## 
  let valid = call_568182.validator(path, query, header, formData, body)
  let scheme = call_568182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568182.url(scheme.get, call_568182.host, call_568182.base,
                         call_568182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568182, url, valid)

proc call*(call_568183: Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_568176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## guestDiagnosticsSettingsAssociationListByResourceGroup
  ## Get a list of all guest diagnostic settings association in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_568184 = newJObject()
  var query_568185 = newJObject()
  add(path_568184, "resourceGroupName", newJString(resourceGroupName))
  add(query_568185, "api-version", newJString(apiVersion))
  add(path_568184, "subscriptionId", newJString(subscriptionId))
  result = call_568183.call(path_568184, query_568185, nil, nil, nil)

var guestDiagnosticsSettingsAssociationListByResourceGroup* = Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_568176(
    name: "guestDiagnosticsSettingsAssociationListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/guestDiagnosticSettingsAssociations",
    validator: validate_GuestDiagnosticsSettingsAssociationListByResourceGroup_568177,
    base: "", url: url_GuestDiagnosticsSettingsAssociationListByResourceGroup_568178,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568196 = ref object of OpenApiRestCall_567642
proc url_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568198(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568197(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates guest diagnostics settings association.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568199 = path.getOrDefault("resourceUri")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "resourceUri", valid_568199
  var valid_568200 = path.getOrDefault("associationName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "associationName", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568201 = query.getOrDefault("api-version")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "api-version", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   diagnosticSettingsAssociation: JObject (required)
  ##                                : The diagnostic settings association to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates guest diagnostics settings association.
  ## 
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568196;
          apiVersion: string; resourceUri: string; associationName: string;
          diagnosticSettingsAssociation: JsonNode): Recallable =
  ## guestDiagnosticsSettingsAssociationCreateOrUpdate
  ## Creates or updates guest diagnostics settings association.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  ##   diagnosticSettingsAssociation: JObject (required)
  ##                                : The diagnostic settings association to create or update.
  var path_568205 = newJObject()
  var query_568206 = newJObject()
  var body_568207 = newJObject()
  add(query_568206, "api-version", newJString(apiVersion))
  add(path_568205, "resourceUri", newJString(resourceUri))
  add(path_568205, "associationName", newJString(associationName))
  if diagnosticSettingsAssociation != nil:
    body_568207 = diagnosticSettingsAssociation
  result = call_568204.call(path_568205, query_568206, nil, nil, body_568207)

var guestDiagnosticsSettingsAssociationCreateOrUpdate* = Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568196(
    name: "guestDiagnosticsSettingsAssociationCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568197,
    base: "", url: url_GuestDiagnosticsSettingsAssociationCreateOrUpdate_568198,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationGet_568186 = ref object of OpenApiRestCall_567642
proc url_GuestDiagnosticsSettingsAssociationGet_568188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationGet_568187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets guest diagnostics association settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568189 = path.getOrDefault("resourceUri")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "resourceUri", valid_568189
  var valid_568190 = path.getOrDefault("associationName")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "associationName", valid_568190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568191 = query.getOrDefault("api-version")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "api-version", valid_568191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568192: Call_GuestDiagnosticsSettingsAssociationGet_568186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets guest diagnostics association settings.
  ## 
  let valid = call_568192.validator(path, query, header, formData, body)
  let scheme = call_568192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568192.url(scheme.get, call_568192.host, call_568192.base,
                         call_568192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568192, url, valid)

proc call*(call_568193: Call_GuestDiagnosticsSettingsAssociationGet_568186;
          apiVersion: string; resourceUri: string; associationName: string): Recallable =
  ## guestDiagnosticsSettingsAssociationGet
  ## Gets guest diagnostics association settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  var path_568194 = newJObject()
  var query_568195 = newJObject()
  add(query_568195, "api-version", newJString(apiVersion))
  add(path_568194, "resourceUri", newJString(resourceUri))
  add(path_568194, "associationName", newJString(associationName))
  result = call_568193.call(path_568194, query_568195, nil, nil, nil)

var guestDiagnosticsSettingsAssociationGet* = Call_GuestDiagnosticsSettingsAssociationGet_568186(
    name: "guestDiagnosticsSettingsAssociationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationGet_568187, base: "",
    url: url_GuestDiagnosticsSettingsAssociationGet_568188,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationUpdate_568218 = ref object of OpenApiRestCall_567642
proc url_GuestDiagnosticsSettingsAssociationUpdate_568220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationUpdate_568219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568238 = path.getOrDefault("resourceUri")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceUri", valid_568238
  var valid_568239 = path.getOrDefault("associationName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "associationName", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_GuestDiagnosticsSettingsAssociationUpdate_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_GuestDiagnosticsSettingsAssociationUpdate_568218;
          apiVersion: string; resourceUri: string; parameters: JsonNode;
          associationName: string): Recallable =
  ## guestDiagnosticsSettingsAssociationUpdate
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  var body_568246 = newJObject()
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "resourceUri", newJString(resourceUri))
  if parameters != nil:
    body_568246 = parameters
  add(path_568244, "associationName", newJString(associationName))
  result = call_568243.call(path_568244, query_568245, nil, nil, body_568246)

var guestDiagnosticsSettingsAssociationUpdate* = Call_GuestDiagnosticsSettingsAssociationUpdate_568218(
    name: "guestDiagnosticsSettingsAssociationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationUpdate_568219,
    base: "", url: url_GuestDiagnosticsSettingsAssociationUpdate_568220,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationDelete_568208 = ref object of OpenApiRestCall_567642
proc url_GuestDiagnosticsSettingsAssociationDelete_568210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationDelete_568209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete guest diagnostics association settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568211 = path.getOrDefault("resourceUri")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceUri", valid_568211
  var valid_568212 = path.getOrDefault("associationName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "associationName", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_GuestDiagnosticsSettingsAssociationDelete_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete guest diagnostics association settings.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_GuestDiagnosticsSettingsAssociationDelete_568208;
          apiVersion: string; resourceUri: string; associationName: string): Recallable =
  ## guestDiagnosticsSettingsAssociationDelete
  ## Delete guest diagnostics association settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "resourceUri", newJString(resourceUri))
  add(path_568216, "associationName", newJString(associationName))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var guestDiagnosticsSettingsAssociationDelete* = Call_GuestDiagnosticsSettingsAssociationDelete_568208(
    name: "guestDiagnosticsSettingsAssociationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationDelete_568209,
    base: "", url: url_GuestDiagnosticsSettingsAssociationDelete_568210,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
