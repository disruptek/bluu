
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: VirtualMachineImageTemplate
## version: 2019-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Virtual Machine Image Template
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "imagebuilder"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.VirtualMachineImages/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesList_568175 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesList_568177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesList_568176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the VM image templates associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568192 = path.getOrDefault("subscriptionId")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "subscriptionId", valid_568192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568193 = query.getOrDefault("api-version")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "api-version", valid_568193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568194: Call_VirtualMachineImageTemplatesList_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the subscription.
  ## 
  let valid = call_568194.validator(path, query, header, formData, body)
  let scheme = call_568194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568194.url(scheme.get, call_568194.host, call_568194.base,
                         call_568194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568194, url, valid)

proc call*(call_568195: Call_VirtualMachineImageTemplatesList_568175;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesList
  ## Gets information about the VM image templates associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_568196 = newJObject()
  var query_568197 = newJObject()
  add(query_568197, "api-version", newJString(apiVersion))
  add(path_568196, "subscriptionId", newJString(subscriptionId))
  result = call_568195.call(path_568196, query_568197, nil, nil, nil)

var virtualMachineImageTemplatesList* = Call_VirtualMachineImageTemplatesList_568175(
    name: "virtualMachineImageTemplatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplatesList_568176, base: "",
    url: url_VirtualMachineImageTemplatesList_568177, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesListByResourceGroup_568198 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesListByResourceGroup_568200(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesListByResourceGroup_568199(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about the VM image templates associated with the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568201 = path.getOrDefault("resourceGroupName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "resourceGroupName", valid_568201
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_VirtualMachineImageTemplatesListByResourceGroup_568198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the specified resource group.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_VirtualMachineImageTemplatesListByResourceGroup_568198;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesListByResourceGroup
  ## Gets information about the VM image templates associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var virtualMachineImageTemplatesListByResourceGroup* = Call_VirtualMachineImageTemplatesListByResourceGroup_568198(
    name: "virtualMachineImageTemplatesListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplatesListByResourceGroup_568199,
    base: "", url: url_VirtualMachineImageTemplatesListByResourceGroup_568200,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesCreateOrUpdate_568219 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesCreateOrUpdate_568221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesCreateOrUpdate_568220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568239 = path.getOrDefault("imageTemplateName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "imageTemplateName", valid_568239
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateImageTemplate operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_VirtualMachineImageTemplatesCreateOrUpdate_568219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a virtual machine image template
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_VirtualMachineImageTemplatesCreateOrUpdate_568219;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplatesCreateOrUpdate
  ## Create or update a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateImageTemplate operation
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  var body_568248 = newJObject()
  add(path_568246, "imageTemplateName", newJString(imageTemplateName))
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568248 = parameters
  result = call_568245.call(path_568246, query_568247, nil, nil, body_568248)

var virtualMachineImageTemplatesCreateOrUpdate* = Call_VirtualMachineImageTemplatesCreateOrUpdate_568219(
    name: "virtualMachineImageTemplatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesCreateOrUpdate_568220,
    base: "", url: url_VirtualMachineImageTemplatesCreateOrUpdate_568221,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesGet_568208 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesGet_568210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesGet_568209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568211 = path.getOrDefault("imageTemplateName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "imageTemplateName", valid_568211
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_VirtualMachineImageTemplatesGet_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a virtual machine image template
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_VirtualMachineImageTemplatesGet_568208;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesGet
  ## Get information about a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "imageTemplateName", newJString(imageTemplateName))
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var virtualMachineImageTemplatesGet* = Call_VirtualMachineImageTemplatesGet_568208(
    name: "virtualMachineImageTemplatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesGet_568209, base: "",
    url: url_VirtualMachineImageTemplatesGet_568210, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesUpdate_568260 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesUpdate_568262(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesUpdate_568261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the tags for this Virtual Machine Image Template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568263 = path.getOrDefault("imageTemplateName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "imageTemplateName", valid_568263
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for Image Template update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_VirtualMachineImageTemplatesUpdate_568260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the tags for this Virtual Machine Image Template
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_VirtualMachineImageTemplatesUpdate_568260;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplatesUpdate
  ## Update the tags for this Virtual Machine Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Additional parameters for Image Template update.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(path_568270, "imageTemplateName", newJString(imageTemplateName))
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568272 = parameters
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var virtualMachineImageTemplatesUpdate* = Call_VirtualMachineImageTemplatesUpdate_568260(
    name: "virtualMachineImageTemplatesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesUpdate_568261, base: "",
    url: url_VirtualMachineImageTemplatesUpdate_568262, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesDelete_568249 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesDelete_568251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesDelete_568250(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a virtual machine image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568252 = path.getOrDefault("imageTemplateName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "imageTemplateName", valid_568252
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_VirtualMachineImageTemplatesDelete_568249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a virtual machine image template
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_VirtualMachineImageTemplatesDelete_568249;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesDelete
  ## Delete a virtual machine image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "imageTemplateName", newJString(imageTemplateName))
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var virtualMachineImageTemplatesDelete* = Call_VirtualMachineImageTemplatesDelete_568249(
    name: "virtualMachineImageTemplatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplatesDelete_568250, base: "",
    url: url_VirtualMachineImageTemplatesDelete_568251, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesRun_568273 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesRun_568275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesRun_568274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create artifacts from a existing image template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568276 = path.getOrDefault("imageTemplateName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "imageTemplateName", valid_568276
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_VirtualMachineImageTemplatesRun_568273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create artifacts from a existing image template
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_VirtualMachineImageTemplatesRun_568273;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesRun
  ## Create artifacts from a existing image template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  add(path_568282, "imageTemplateName", newJString(imageTemplateName))
  add(path_568282, "resourceGroupName", newJString(resourceGroupName))
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  result = call_568281.call(path_568282, query_568283, nil, nil, nil)

var virtualMachineImageTemplatesRun* = Call_VirtualMachineImageTemplatesRun_568273(
    name: "virtualMachineImageTemplatesRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/run",
    validator: validate_VirtualMachineImageTemplatesRun_568274, base: "",
    url: url_VirtualMachineImageTemplatesRun_568275, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesListRunOutputs_568284 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesListRunOutputs_568286(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName"),
               (kind: ConstantSegment, value: "/runOutputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesListRunOutputs_568285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all run outputs for the specified Image Template resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568287 = path.getOrDefault("imageTemplateName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "imageTemplateName", valid_568287
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("subscriptionId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "subscriptionId", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_VirtualMachineImageTemplatesListRunOutputs_568284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all run outputs for the specified Image Template resource
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_VirtualMachineImageTemplatesListRunOutputs_568284;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplatesListRunOutputs
  ## List all run outputs for the specified Image Template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "imageTemplateName", newJString(imageTemplateName))
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var virtualMachineImageTemplatesListRunOutputs* = Call_VirtualMachineImageTemplatesListRunOutputs_568284(
    name: "virtualMachineImageTemplatesListRunOutputs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs",
    validator: validate_VirtualMachineImageTemplatesListRunOutputs_568285,
    base: "", url: url_VirtualMachineImageTemplatesListRunOutputs_568286,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplatesGetRunOutput_568295 = ref object of OpenApiRestCall_567657
proc url_VirtualMachineImageTemplatesGetRunOutput_568297(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageTemplateName" in path,
        "`imageTemplateName` is a required path parameter"
  assert "runOutputName" in path, "`runOutputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VirtualMachineImages/imageTemplates/"),
               (kind: VariableSegment, value: "imageTemplateName"),
               (kind: ConstantSegment, value: "/runOutputs/"),
               (kind: VariableSegment, value: "runOutputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImageTemplatesGetRunOutput_568296(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified run output for the specified image template resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   runOutputName: JString (required)
  ##                : The name of the run output
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568298 = path.getOrDefault("imageTemplateName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "imageTemplateName", valid_568298
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  var valid_568301 = path.getOrDefault("runOutputName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "runOutputName", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_VirtualMachineImageTemplatesGetRunOutput_568295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified run output for the specified image template resource
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_VirtualMachineImageTemplatesGetRunOutput_568295;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; runOutputName: string): Recallable =
  ## virtualMachineImageTemplatesGetRunOutput
  ## Get the specified run output for the specified image template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription Id forms part of the URI for every service call.
  ##   runOutputName: string (required)
  ##                : The name of the run output
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  add(path_568305, "imageTemplateName", newJString(imageTemplateName))
  add(path_568305, "resourceGroupName", newJString(resourceGroupName))
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "subscriptionId", newJString(subscriptionId))
  add(path_568305, "runOutputName", newJString(runOutputName))
  result = call_568304.call(path_568305, query_568306, nil, nil, nil)

var virtualMachineImageTemplatesGetRunOutput* = Call_VirtualMachineImageTemplatesGetRunOutput_568295(
    name: "virtualMachineImageTemplatesGetRunOutput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs/{runOutputName}",
    validator: validate_VirtualMachineImageTemplatesGetRunOutput_568296, base: "",
    url: url_VirtualMachineImageTemplatesGetRunOutput_568297,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
