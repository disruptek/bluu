
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: VirtualMachineImageTemplate
## version: 2018-02-01-preview
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_OperationsList_567863; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.VirtualMachineImages provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.VirtualMachineImages/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateList_568159 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateList_568161(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplateList_568160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the VM image templates associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568176 = path.getOrDefault("subscriptionId")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "subscriptionId", valid_568176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568177 = query.getOrDefault("api-version")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "api-version", valid_568177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568178: Call_VirtualMachineImageTemplateList_568159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the subscription.
  ## 
  let valid = call_568178.validator(path, query, header, formData, body)
  let scheme = call_568178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568178.url(scheme.get, call_568178.host, call_568178.base,
                         call_568178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568178, url, valid)

proc call*(call_568179: Call_VirtualMachineImageTemplateList_568159;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineImageTemplateList
  ## Gets information about the VM image templates associated with the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568180 = newJObject()
  var query_568181 = newJObject()
  add(query_568181, "api-version", newJString(apiVersion))
  add(path_568180, "subscriptionId", newJString(subscriptionId))
  result = call_568179.call(path_568180, query_568181, nil, nil, nil)

var virtualMachineImageTemplateList* = Call_VirtualMachineImageTemplateList_568159(
    name: "virtualMachineImageTemplateList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplateList_568160, base: "",
    url: url_VirtualMachineImageTemplateList_568161, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateListByResourceGroup_568182 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateListByResourceGroup_568184(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplateListByResourceGroup_568183(
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
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568185 = path.getOrDefault("resourceGroupName")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "resourceGroupName", valid_568185
  var valid_568186 = path.getOrDefault("subscriptionId")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "subscriptionId", valid_568186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_VirtualMachineImageTemplateListByResourceGroup_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the VM image templates associated with the specified resource group.
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_VirtualMachineImageTemplateListByResourceGroup_568182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineImageTemplateListByResourceGroup
  ## Gets information about the VM image templates associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568190 = newJObject()
  var query_568191 = newJObject()
  add(path_568190, "resourceGroupName", newJString(resourceGroupName))
  add(query_568191, "api-version", newJString(apiVersion))
  add(path_568190, "subscriptionId", newJString(subscriptionId))
  result = call_568189.call(path_568190, query_568191, nil, nil, nil)

var virtualMachineImageTemplateListByResourceGroup* = Call_VirtualMachineImageTemplateListByResourceGroup_568182(
    name: "virtualMachineImageTemplateListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates",
    validator: validate_VirtualMachineImageTemplateListByResourceGroup_568183,
    base: "", url: url_VirtualMachineImageTemplateListByResourceGroup_568184,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateCreateOrUpdate_568203 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateCreateOrUpdate_568205(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplateCreateOrUpdate_568204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or Update a Virtual Machine Image Template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568223 = path.getOrDefault("imageTemplateName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "imageTemplateName", valid_568223
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Image Template
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_VirtualMachineImageTemplateCreateOrUpdate_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or Update a Virtual Machine Image Template
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_VirtualMachineImageTemplateCreateOrUpdate_568203;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplateCreateOrUpdate
  ## Create or Update a Virtual Machine Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Image Template
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  var body_568232 = newJObject()
  add(path_568230, "imageTemplateName", newJString(imageTemplateName))
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568232 = parameters
  result = call_568229.call(path_568230, query_568231, nil, nil, body_568232)

var virtualMachineImageTemplateCreateOrUpdate* = Call_VirtualMachineImageTemplateCreateOrUpdate_568203(
    name: "virtualMachineImageTemplateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplateCreateOrUpdate_568204,
    base: "", url: url_VirtualMachineImageTemplateCreateOrUpdate_568205,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateGet_568192 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateGet_568194(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplateGet_568193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Information about Virtual Machine Image Template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568195 = path.getOrDefault("imageTemplateName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "imageTemplateName", valid_568195
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_VirtualMachineImageTemplateGet_568192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Information about Virtual Machine Image Template
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_VirtualMachineImageTemplateGet_568192;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplateGet
  ## Get Information about Virtual Machine Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "imageTemplateName", newJString(imageTemplateName))
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var virtualMachineImageTemplateGet* = Call_VirtualMachineImageTemplateGet_568192(
    name: "virtualMachineImageTemplateGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplateGet_568193, base: "",
    url: url_VirtualMachineImageTemplateGet_568194, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateUpdate_568244 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateUpdate_568246(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplateUpdate_568245(path: JsonNode;
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
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568247 = path.getOrDefault("imageTemplateName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "imageTemplateName", valid_568247
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
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

proc call*(call_568252: Call_VirtualMachineImageTemplateUpdate_568244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the tags for this Virtual Machine Image Template
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_VirtualMachineImageTemplateUpdate_568244;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineImageTemplateUpdate
  ## Update the tags for this Virtual Machine Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Additional parameters for Image Template update.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  var body_568256 = newJObject()
  add(path_568254, "imageTemplateName", newJString(imageTemplateName))
  add(path_568254, "resourceGroupName", newJString(resourceGroupName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568256 = parameters
  result = call_568253.call(path_568254, query_568255, nil, nil, body_568256)

var virtualMachineImageTemplateUpdate* = Call_VirtualMachineImageTemplateUpdate_568244(
    name: "virtualMachineImageTemplateUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplateUpdate_568245, base: "",
    url: url_VirtualMachineImageTemplateUpdate_568246, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateDelete_568233 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateDelete_568235(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplateDelete_568234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Virtual Machine Image Template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568236 = path.getOrDefault("imageTemplateName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "imageTemplateName", valid_568236
  var valid_568237 = path.getOrDefault("resourceGroupName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceGroupName", valid_568237
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_VirtualMachineImageTemplateDelete_568233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete Virtual Machine Image Template
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_VirtualMachineImageTemplateDelete_568233;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplateDelete
  ## Delete Virtual Machine Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(path_568242, "imageTemplateName", newJString(imageTemplateName))
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var virtualMachineImageTemplateDelete* = Call_VirtualMachineImageTemplateDelete_568233(
    name: "virtualMachineImageTemplateDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}",
    validator: validate_VirtualMachineImageTemplateDelete_568234, base: "",
    url: url_VirtualMachineImageTemplateDelete_568235, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateRun_568257 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateRun_568259(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImageTemplateRun_568258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create artifacts from a existing Image Template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568260 = path.getOrDefault("imageTemplateName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "imageTemplateName", valid_568260
  var valid_568261 = path.getOrDefault("resourceGroupName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceGroupName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568263 = query.getOrDefault("api-version")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "api-version", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_VirtualMachineImageTemplateRun_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create artifacts from a existing Image Template
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_VirtualMachineImageTemplateRun_568257;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplateRun
  ## Create artifacts from a existing Image Template
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  add(path_568266, "imageTemplateName", newJString(imageTemplateName))
  add(path_568266, "resourceGroupName", newJString(resourceGroupName))
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  result = call_568265.call(path_568266, query_568267, nil, nil, nil)

var virtualMachineImageTemplateRun* = Call_VirtualMachineImageTemplateRun_568257(
    name: "virtualMachineImageTemplateRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/run",
    validator: validate_VirtualMachineImageTemplateRun_568258, base: "",
    url: url_VirtualMachineImageTemplateRun_568259, schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateListRunOutputs_568268 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateListRunOutputs_568270(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplateListRunOutputs_568269(path: JsonNode;
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
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568271 = path.getOrDefault("imageTemplateName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "imageTemplateName", valid_568271
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_VirtualMachineImageTemplateListRunOutputs_568268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all run outputs for the specified Image Template resource
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_VirtualMachineImageTemplateListRunOutputs_568268;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineImageTemplateListRunOutputs
  ## List all run outputs for the specified Image Template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(path_568277, "imageTemplateName", newJString(imageTemplateName))
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var virtualMachineImageTemplateListRunOutputs* = Call_VirtualMachineImageTemplateListRunOutputs_568268(
    name: "virtualMachineImageTemplateListRunOutputs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs",
    validator: validate_VirtualMachineImageTemplateListRunOutputs_568269,
    base: "", url: url_VirtualMachineImageTemplateListRunOutputs_568270,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineImageTemplateGetRunOutput_568279 = ref object of OpenApiRestCall_567641
proc url_VirtualMachineImageTemplateGetRunOutput_568281(protocol: Scheme;
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

proc validate_VirtualMachineImageTemplateGetRunOutput_568280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified run output for the specified Template resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageTemplateName: JString (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   runOutputName: JString (required)
  ##                : The name of the run output
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `imageTemplateName` field"
  var valid_568282 = path.getOrDefault("imageTemplateName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "imageTemplateName", valid_568282
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  var valid_568285 = path.getOrDefault("runOutputName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "runOutputName", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "api-version", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568287: Call_VirtualMachineImageTemplateGetRunOutput_568279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified run output for the specified Template resource
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_VirtualMachineImageTemplateGetRunOutput_568279;
          imageTemplateName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; runOutputName: string): Recallable =
  ## virtualMachineImageTemplateGetRunOutput
  ## Get the specified run output for the specified Template resource
  ##   imageTemplateName: string (required)
  ##                    : The name of the image Template
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   runOutputName: string (required)
  ##                : The name of the run output
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  add(path_568289, "imageTemplateName", newJString(imageTemplateName))
  add(path_568289, "resourceGroupName", newJString(resourceGroupName))
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  add(path_568289, "runOutputName", newJString(runOutputName))
  result = call_568288.call(path_568289, query_568290, nil, nil, nil)

var virtualMachineImageTemplateGetRunOutput* = Call_VirtualMachineImageTemplateGetRunOutput_568279(
    name: "virtualMachineImageTemplateGetRunOutput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VirtualMachineImages/imageTemplates/{imageTemplateName}/runOutputs/{runOutputName}",
    validator: validate_VirtualMachineImageTemplateGetRunOutput_568280, base: "",
    url: url_VirtualMachineImageTemplateGetRunOutput_568281,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
